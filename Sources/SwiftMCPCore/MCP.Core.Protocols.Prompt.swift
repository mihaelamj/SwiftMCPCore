import Foundation

// MARK: - Prompts

// The prompts family of the MCP wire protocol. Present so this package models the
// full protocol surface; a pure client may not exercise the prompt verbs.

/// A prompt that can be retrieved by the client
public extension MCP.Core.Protocols {
    struct Prompt: Codable, Sendable {
        public let name: String
        public let description: String?
        public let arguments: [PromptArgument]?

        public init(
            name: String,
            description: String? = nil,
            arguments: [PromptArgument]? = nil,
        ) {
            self.name = name
            self.description = description
            self.arguments = arguments
        }
    }
}

/// Argument definition for a prompt
public extension MCP.Core.Protocols {
    struct PromptArgument: Codable, Sendable {
        public let name: String
        public let description: String?
        public let required: Bool?

        public init(
            name: String,
            description: String? = nil,
            required: Bool? = nil,
        ) {
            self.name = name
            self.description = description
            self.required = required
        }
    }
}

/// A message in a prompt (user or assistant role)
public extension MCP.Core.Protocols {
    struct PromptMessage: Codable, Sendable {
        public let role: Role
        public let content: ContentBlock

        public init(role: Role, content: ContentBlock) {
            self.role = role
            self.content = content
        }

        public enum Role: String, Codable, Sendable {
            case user
            case assistant
        }
    }
}

// MARK: - Prompt Requests/Responses

/// List all available prompts
public extension MCP.Core.Protocols {
    struct ListPromptsRequest: Codable, Sendable {
        public let method: String = Method.promptsList
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
    struct ListPromptsResult: Codable, Sendable {
        public let prompts: [Prompt]
        public let nextCursor: String?

        public init(prompts: [Prompt], nextCursor: String? = nil) {
            self.prompts = prompts
            self.nextCursor = nextCursor
        }
    }
}

/// Get a specific prompt
public extension MCP.Core.Protocols {
    struct GetPromptRequest: Codable, Sendable {
        public let method: String = Method.promptsGet
        public let params: Params

        enum CodingKeys: String, CodingKey {
            case params
        }

        public init(name: String, arguments: [String: String]? = nil) {
            params = Params(name: name, arguments: arguments)
        }

        public struct Params: Codable, Sendable {
            public let name: String
            public let arguments: [String: String]?

            public init(name: String, arguments: [String: String]? = nil) {
                self.name = name
                self.arguments = arguments
            }
        }
    }
}

public extension MCP.Core.Protocols {
    struct GetPromptResult: Codable, Sendable {
        public let description: String?
        public let messages: [PromptMessage]

        public init(description: String? = nil, messages: [PromptMessage]) {
            self.description = description
            self.messages = messages
        }
    }
}

/// Prompt list changed notification (server to client)
public extension MCP.Core.Protocols {
    struct PromptListChangedNotification: Codable, Sendable {
        public let method: String = Method.notificationsPromptsListChanged

        enum CodingKeys: String, CodingKey {
            case method
        }

        public init() {}
    }
}
