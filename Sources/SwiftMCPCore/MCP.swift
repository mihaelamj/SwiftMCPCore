import Foundation

// MARK: - MCP Namespace

/// Namespace for Model Context Protocol (MCP) wire types.
///
/// This is the neutral, dependency-free wire-protocol core: the JSON-RPC + MCP
/// value types described by the MCP specification, shared by independent MCP
/// clients and servers. It owns the `MCP` / `MCP.Core` / `MCP.Core.Protocols`
/// anchor and every wire type (requests, responses, content blocks, tools,
/// resources, prompts, capabilities), and nothing else: no transport, no server
/// runtime, no client. Consumers add their own transport under their own
/// `MCP.Core.Transport` sub-namespace.
///
/// - `MCP.Core.Protocols.*` carries the wire-format types. (The namespace cannot
///   be named `Protocol` because Swift reserves `.Protocol` as a metatype member
///   on every type.)
public enum MCP {
    /// Root of the cross-platform MCP runtime. Types live as
    /// `MCP.Core.<Category>.<Name>` so the fully qualified name carries the
    /// folder of origin.
    public enum Core {
        /// Wire-format types described by the MCP specification: request /
        /// response envelopes, content blocks, server / client capabilities.
        public enum Protocols {}
    }
}
