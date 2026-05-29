import Foundation

// MARK: - MCP Protocol Version

/// Current MCP protocol version this kit handshakes with. Mirrors cupertino's
/// `MCPProtocolVersion` verbatim so the wire handshake is byte-identical.
public let MCPProtocolVersion = "2025-11-25"

/// Protocol versions this kit can speak, newest first. Mirrors cupertino.
public let MCPProtocolVersionsSupported = [
    MCPProtocolVersion,
    "2025-06-18",
    "2024-11-05",
]
