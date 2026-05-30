import Foundation
@testable import SwiftMCPCore
import Testing

/// Broad coverage of the wire surface: the protocol constants, and an
/// encode-then-decode round trip (or a decode from a literal frame) for every
/// value type, so a regression in any field name or JSON shape is caught.
@Suite("MCPCore coverage")
struct MCPCoreCoverageTests {
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    private let decoder = JSONDecoder()

    private func roundTrip<Value: Codable>(_ value: Value, as _: Value.Type) throws -> Value {
        try decoder.decode(Value.self, from: encoder.encode(value))
    }

    // MARK: - Constants

    @Test("the protocol version and supported list match the spec")
    func protocolVersions() {
        #expect(MCPProtocolVersion == "2025-11-25")
        #expect(MCPProtocolVersionsSupported.first == "2025-11-25")
        #expect(MCPProtocolVersionsSupported == ["2025-11-25", "2025-06-18", "2024-11-05"])
    }

    @Test("every Method identifier is its exact JSON-RPC method string")
    func methodStrings() {
        typealias M = MCP.Core.Protocols.Method
        #expect(M.initialize == "initialize")
        #expect(M.resourcesList == "resources/list")
        #expect(M.resourcesRead == "resources/read")
        #expect(M.resourcesTemplatesList == "resources/templates/list")
        #expect(M.resourcesSubscribe == "resources/subscribe")
        #expect(M.resourcesUnsubscribe == "resources/unsubscribe")
        #expect(M.toolsList == "tools/list")
        #expect(M.toolsCall == "tools/call")
        #expect(M.promptsList == "prompts/list")
        #expect(M.promptsGet == "prompts/get")
        #expect(M.notificationsInitialized == "notifications/initialized")
        #expect(M.notificationsResourcesUpdated == "notifications/resources/updated")
        #expect(M.notificationsResourcesListChanged == "notifications/resources/list_changed")
        #expect(M.notificationsToolsListChanged == "notifications/tools/list_changed")
        #expect(M.notificationsPromptsListChanged == "notifications/prompts/list_changed")
    }

    @Test("error codes carry the standard JSON-RPC + MCP numeric values and messages")
    func errorCodes() {
        typealias E = MCP.Core.Protocols.ErrorCode
        #expect(E.parseError.rawValue == -32700)
        #expect(E.invalidRequest.rawValue == -32600)
        #expect(E.methodNotFound.rawValue == -32601)
        #expect(E.invalidParams.rawValue == -32602)
        #expect(E.internalError.rawValue == -32603)
        #expect(E.connectionClosed.rawValue == -32000)
        #expect(E.requestTimeout.rawValue == -32001)
        #expect(E.parseError.message == "Parse error")
        #expect(E.requestTimeout.message == "Request timeout")
    }

    @Test("content type identifiers are text/image/resource")
    func contentTypes() {
        #expect(MCP.Core.Protocols.ContentType.text == "text")
        #expect(MCP.Core.Protocols.ContentType.image == "image")
        #expect(MCP.Core.Protocols.ContentType.resource == "resource")
    }

    // MARK: - JSON-RPC envelopes

    @Test("a success response decodes id + result")
    func successResponse() throws {
        let data = Data(#"{"jsonrpc":"2.0","id":42,"result":{"ok":true}}"#.utf8)
        let response = try decoder.decode(MCP.Core.Protocols.JSONRPCResponse.self, from: data)
        #expect(response.id == .int(42))
        #expect(response.result["ok"]?.value as? Bool == true)
    }

    @Test("an error response decodes its ErrorDetail (code, message, data)")
    func errorResponse() throws {
        let data = Data(#"{"jsonrpc":"2.0","id":"abc","error":{"code":-32601,"message":"Method not found","data":{"method":"x"}}}"#.utf8)
        let error = try decoder.decode(MCP.Core.Protocols.JSONRPCError.self, from: data)
        #expect(error.id == .string("abc"))
        #expect(error.error.code == -32601)
        #expect(error.error.message == "Method not found")
        #expect(error.error.data?.dictionaryValue?["method"]?.value as? String == "x")
    }

    @Test("a notification encodes a method + params and carries no id")
    func notification() throws {
        let note = MCP.Core.Protocols.JSONRPCNotification(
            method: "notifications/tools/list_changed",
            params: nil,
        )
        let json = try String(decoding: encoder.encode(note), as: UTF8.self)
        #expect(json.contains("\"jsonrpc\":\"2.0\""))
        #expect(json.contains("notifications"))
        #expect(!json.contains("\"id\""))
    }

    @Test("EmptyParams encodes to an empty object")
    func emptyParams() throws {
        let json = try String(decoding: encoder.encode(MCP.Core.Protocols.EmptyParams()), as: UTF8.self)
        #expect(json == "{}")
    }

    // MARK: - JSON values

    @Test("JSONValue round-trips every case")
    func jsonValueRoundTrip() throws {
        let value = MCP.Core.Protocols.JSONValue.object([
            "s": .string("x"),
            "n": .number(1.5),
            "b": .bool(false),
            "z": .null,
            "a": .array([.string("y"), .number(2)]),
        ])
        let decoded = try roundTrip(value, as: MCP.Core.Protocols.JSONValue.self)
        guard case let .object(obj) = decoded else { Issue.record("expected object")
            return
        }
        if case let .number(n) = obj["n"] { #expect(n == 1.5) } else { Issue.record("n") }
        if case .null = obj["z"] {} else { Issue.record("z should be null") }
    }

    @Test("AnyCodable preserves null and nested structure through a round trip")
    func anyCodableNested() throws {
        let data = Data(#"{"a":[1,2],"b":{"c":null}}"#.utf8)
        let decoded = try decoder.decode([String: MCP.Core.Protocols.AnyCodable].self, from: data)
        let re = try decoder.decode([String: MCP.Core.Protocols.AnyCodable].self, from: encoder.encode(decoded))
        #expect((re["a"]?.value as? [Any])?.count == 2)
        #expect(re["b"]?.dictionaryValue?["c"]?.value is NSNull)
    }

    // MARK: - Content blocks (incl. base64)

    @Test("an image content block carries base64 data + mimeType")
    func imageContent() throws {
        let data = Data(#"{"type":"image","data":"aGVsbG8=","mimeType":"image/png"}"#.utf8)
        let block = try decoder.decode(MCP.Core.Protocols.ContentBlock.self, from: data)
        guard case let .image(image) = block else { Issue.record("expected image")
            return
        }
        #expect(image.data == "aGVsbG8=")
        #expect(image.mimeType == "image/png")
        #expect(Data(base64Encoded: image.data) == Data("hello".utf8))
    }

    @Test("an embedded text resource decodes through ContentBlock and ResourceContents")
    func embeddedTextResource() throws {
        let data = Data(#"{"type":"resource","resource":{"uri":"apple-docs://x","mimeType":"text/markdown","text":"Title body"}}"#.utf8)
        let block = try decoder.decode(MCP.Core.Protocols.ContentBlock.self, from: data)
        guard case let .resource(embedded) = block, case let .text(text) = embedded.resource else {
            Issue.record("expected an embedded text resource")
            return
        }
        #expect(text.uri == "apple-docs://x")
        #expect(text.text == "Title body")
    }

    @Test("a blob resource carries base64 blob data")
    func blobResource() throws {
        let data = Data(#"{"uri":"file://x","mimeType":"application/octet-stream","blob":"AAEC"}"#.utf8)
        let contents = try decoder.decode(MCP.Core.Protocols.ResourceContents.self, from: data)
        guard case let .blob(blob) = contents else { Issue.record("expected blob")
            return
        }
        #expect(blob.blob == "AAEC")
        #expect(Data(base64Encoded: blob.blob) == Data([0, 1, 2]))
    }

    // MARK: - Icon (new in 2025-11-25)

    @Test("an Icon round-trips, including a base64 data: URI src and sizes")
    func iconRoundTrip() throws {
        let icon = MCP.Core.Protocols.Icon(
            src: "data:image/png;base64,aGVsbG8=",
            mimeType: "image/png",
            sizes: ["48x48", "any"],
        )
        let decoded = try roundTrip(icon, as: MCP.Core.Protocols.Icon.self)
        #expect(decoded == icon)
        #expect(decoded.src.hasPrefix("data:image/png;base64,"))
        #expect(decoded.sizes == ["48x48", "any"])
    }

    @Test("Implementation decodes with icons, and tolerates the field being absent")
    func implementationIconsOptional() throws {
        let withIcons = Data(#"{"name":"server","version":"1.0","icons":[{"src":"https://x/i.png"}]}"#.utf8)
        let a = try decoder.decode(MCP.Core.Protocols.Implementation.self, from: withIcons)
        #expect(a.icons?.count == 1)
        #expect(a.icons?.first?.src == "https://x/i.png")

        let withoutIcons = Data(#"{"name":"server","version":"1.0"}"#.utf8)
        let b = try decoder.decode(MCP.Core.Protocols.Implementation.self, from: withoutIcons)
        #expect(b.name == "server")
        #expect(b.icons == nil)
    }

    // MARK: - Tools / resources

    @Test("a Tool with a JSONSchema decodes its name, description, and schema")
    func toolDecoding() throws {
        let data = Data(#"{"name":"search","description":"find","inputSchema":{"type":"object","properties":{"q":{"type":"string"}},"required":["q"]}}"#.utf8)
        let tool = try decoder.decode(MCP.Core.Protocols.Tool.self, from: data)
        #expect(tool.name == "search")
        #expect(tool.description == "find")
        #expect(tool.inputSchema.type == "object")
        #expect(tool.inputSchema.required == ["q"])
        #expect(tool.inputSchema.properties?["q"] != nil)
    }

    @Test("a Resource decodes its uri/name/description/mimeType")
    func resourceDecoding() throws {
        let data = Data(#"{"uri":"apple-docs://swiftui","name":"SwiftUI","description":"docs","mimeType":"text/markdown"}"#.utf8)
        let resource = try decoder.decode(MCP.Core.Protocols.Resource.self, from: data)
        #expect(resource.uri == "apple-docs://swiftui")
        #expect(resource.name == "SwiftUI")
        #expect(resource.mimeType == "text/markdown")
    }

    @Test("a ReadResourceResult decodes its contents array")
    func readResourceResult() throws {
        let data = Data(#"{"contents":[{"uri":"u","text":"body"}]}"#.utf8)
        let result = try decoder.decode(MCP.Core.Protocols.ReadResourceResult.self, from: data)
        #expect(result.contents.count == 1)
        guard case let .text(text) = result.contents[0] else { Issue.record("expected text")
            return
        }
        #expect(text.text == "body")
    }

    // MARK: - Initialize / capabilities

    @Test("an InitializeResult decodes protocolVersion, capabilities, serverInfo")
    func initializeResult() throws {
        let data = Data(#"{"protocolVersion":"2025-11-25","capabilities":{"tools":{"listChanged":true}},"serverInfo":{"name":"s","version":"1"},"instructions":"hi"}"#.utf8)
        let result = try decoder.decode(MCP.Core.Protocols.InitializeResult.self, from: data)
        #expect(result.protocolVersion == "2025-11-25")
        #expect(result.capabilities.tools?.listChanged == true)
        #expect(result.serverInfo.name == "s")
        #expect(result.instructions == "hi")
    }

    @Test("an InitializeRequest carries the initialize method and params")
    func initializeRequest() throws {
        let request = MCP.Core.Protocols.InitializeRequest(
            protocolVersion: MCPProtocolVersion,
            capabilities: MCP.Core.Protocols.ClientCapabilities(),
            clientInfo: MCP.Core.Protocols.Implementation(name: "c", version: "1"),
        )
        #expect(request.method == "initialize")
        let json = try String(decoding: encoder.encode(request), as: UTF8.self)
        #expect(json.contains("\"protocolVersion\":\"2025-11-25\""))
        #expect(json.contains("\"name\":\"c\""))
    }

    // MARK: - Prompts

    @Test("the prompts family decodes (Prompt, PromptArgument, list/get results)")
    func promptsFamily() throws {
        let list = Data(#"{"prompts":[{"name":"p","description":"d","arguments":[{"name":"a","required":true}]}]}"#.utf8)
        let listResult = try decoder.decode(MCP.Core.Protocols.ListPromptsResult.self, from: list)
        #expect(listResult.prompts.first?.name == "p")
        #expect(listResult.prompts.first?.arguments?.first?.required == true)

        let get = Data(#"{"description":"d","messages":[{"role":"user","content":{"type":"text","text":"hi"}}]}"#.utf8)
        let getResult = try decoder.decode(MCP.Core.Protocols.GetPromptResult.self, from: get)
        #expect(getResult.messages.first?.role == .user)
        guard case let .text(text) = getResult.messages.first?.content else { Issue.record("text")
            return
        }
        #expect(text.text == "hi")
    }
}
