import Foundation

// MARK: - Tools

/// A tool that can be called by the client
public extension MCP.Core.Protocols {
    struct Tool: Codable, Sendable {
        public let name: String
        public let description: String?
        public let inputSchema: JSONSchema

        public init(
            name: String,
            description: String? = nil,
            inputSchema: JSONSchema,
        ) {
            self.name = name
            self.description = description
            self.inputSchema = inputSchema
        }
    }
}

/// JSON Schema for tool input validation
public extension MCP.Core.Protocols {
    struct JSONSchema: Codable, Sendable {
        public let type: String
        public let properties: [String: AnyCodable]?
        public let required: [String]?

        public init(
            type: String = "object",
            properties: [String: AnyCodable]? = nil,
            required: [String]? = nil,
        ) {
            self.type = type
            self.properties = properties
            self.required = required
        }
    }
}

// MARK: - Tool Requests/Responses

/// List all available tools
public extension MCP.Core.Protocols {
    struct ListToolsRequest: Codable, Sendable {
        public let method: String = Method.toolsList
        public let params: Params?

        enum CodingKeys: String, CodingKey {
            case params
        }

        public init(cursor: String? = nil) {
            params = cursor.map { Params(cursor: $0) }
        }

        public struct Params: Codable, Sendable {
            public let cursor: String

            public init(cursor: String) {
                self.cursor = cursor
            }
        }
    }
}

public extension MCP.Core.Protocols {
    struct ListToolsResult: Codable, Sendable {
        public let tools: [Tool]
        public let nextCursor: String?

        public init(tools: [Tool], nextCursor: String? = nil) {
            self.tools = tools
            self.nextCursor = nextCursor
        }
    }
}

/// Call a tool
public extension MCP.Core.Protocols {
    struct CallToolRequest: Codable, Sendable {
        public let method: String = Method.toolsCall
        public let params: Params

        enum CodingKeys: String, CodingKey {
            case params
        }

        public init(name: String, arguments: [String: AnyCodable]? = nil) {
            params = Params(name: name, arguments: arguments)
        }

        public struct Params: Codable, Sendable {
            public let name: String
            public let arguments: [String: AnyCodable]?

            public init(name: String, arguments: [String: AnyCodable]? = nil) {
                self.name = name
                self.arguments = arguments
            }
        }
    }
}

public extension MCP.Core.Protocols {
    struct CallToolResult: Codable, Sendable {
        public let content: [ContentBlock]
        public let isError: Bool?

        public init(content: [ContentBlock], isError: Bool? = nil) {
            self.content = content
            self.isError = isError
        }
    }
}

/// Tool list changed notification (server → client)
public extension MCP.Core.Protocols {
    struct ToolListChangedNotification: Codable, Sendable {
        public let method: String = Method.notificationsToolsListChanged

        enum CodingKeys: String, CodingKey {
            case method
        }

        public init() {}
    }
}

// MARK: - Type Aliases

public extension MCP.Core.Protocols {
    typealias CallToolParams = CallToolRequest.Params
}
