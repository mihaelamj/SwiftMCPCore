import Foundation
@testable import SwiftMCPCore
import Testing

/// Wire-shape tests: the core's value is that its JSON matches the MCP spec
/// exactly, so these pin the on-the-wire encoding/decoding rather than internals.
@Suite("MCPCore wire shapes")
struct MCPCoreWireTests {
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    private let decoder = JSONDecoder()

    @Test("RequestID encodes as a bare int or string, not an object")
    func requestIDEncoding() throws {
        let intID = try String(decoding: encoder.encode(MCP.Core.Protocols.RequestID.int(7)), as: UTF8.self)
        #expect(intID == "7")
        let stringID = try String(decoding: encoder.encode(MCP.Core.Protocols.RequestID.string("abc")), as: UTF8.self)
        #expect(stringID == "\"abc\"")
    }

    @Test("a tools/call request carries jsonrpc, id, method, params")
    func requestEncoding() throws {
        let request = MCP.Core.Protocols.Request(
            id: .int(1),
            method: "tools/call",
            params: MCP.Core.Protocols.CallToolRequest.Params(name: "list_frameworks", arguments: nil),
        )
        let json = try String(decoding: encoder.encode(request), as: UTF8.self)
        #expect(json.contains("\"jsonrpc\":\"2.0\""))
        #expect(json.contains("\"id\":1"))
        #expect(json.contains("\"method\":\"tools\\/call\"") || json.contains("\"method\":\"tools/call\""))
    }

    @Test("a text content block decodes from its typed JSON")
    func contentBlockDecoding() throws {
        let data = Data(#"{"type":"text","text":"hello"}"#.utf8)
        let block = try decoder.decode(MCP.Core.Protocols.ContentBlock.self, from: data)
        guard case let .text(content) = block else {
            Issue.record("expected a text content block")
            return
        }
        #expect(content.text == "hello")
    }

    @Test("a CallToolResult decodes its content array and isError")
    func callToolResultDecoding() throws {
        let data = Data(#"{"content":[{"type":"text","text":"ok"}],"isError":false}"#.utf8)
        let result = try decoder.decode(MCP.Core.Protocols.CallToolResult.self, from: data)
        #expect(result.content.count == 1)
        #expect(result.isError == false)
    }

    @Test("AnyCodable round-trips a heterogeneous dictionary")
    func anyCodableRoundTrip() throws {
        let original = Data(#"{"limit":10,"q":"swiftui","exact":true}"#.utf8)
        let decoded = try decoder.decode([String: MCP.Core.Protocols.AnyCodable].self, from: original)
        let reencoded = try encoder.encode(decoded)
        let roundTripped = try decoder.decode([String: MCP.Core.Protocols.AnyCodable].self, from: reencoded)
        #expect(roundTripped["q"]?.value as? String == "swiftui")
        #expect(roundTripped["limit"]?.value as? Int == 10)
        #expect(roundTripped["exact"]?.value as? Bool == true)
    }

    @Test("the prompts superset is present and decodes (Role cases match the spec)")
    func promptMessageDecoding() throws {
        let data = Data(#"{"role":"assistant","content":{"type":"text","text":"hi"}}"#.utf8)
        let message = try decoder.decode(MCP.Core.Protocols.PromptMessage.self, from: data)
        #expect(message.role == .assistant)
        #expect(MCP.Core.Protocols.PromptMessage.Role(rawValue: "user") == .user)
    }

    @Test("the protocol version is the expected MCP spec date")
    func protocolVersion() {
        #expect(MCPProtocolVersion == "2025-11-25")
    }
}
