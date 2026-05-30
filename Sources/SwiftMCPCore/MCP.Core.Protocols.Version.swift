import Foundation

// MARK: - MCP Protocol Version

/// The current MCP protocol version, as published in the MCP specification. A
/// client and server agree on a version during the `initialize` handshake.
public let MCPProtocolVersion = "2025-11-25"

/// The MCP protocol versions this package models, newest first.
public let MCPProtocolVersionsSupported = [
    MCPProtocolVersion,
    "2025-06-18",
    "2024-11-05",
]
