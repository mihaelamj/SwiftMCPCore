# Design: swift-mcp-core

Status: **accepted.**

## What this is

The neutral, dependency-free wire-protocol core for the Model Context Protocol: the
JSON-RPC 2.0 + MCP value types, and nothing else. One Foundation-only,
cross-platform module, `SwiftMCPCore`, owning the `MCP.Core.Protocols.*` namespace.

## Goals

- Be the single shared definition of the MCP wire types, so independent MCP clients
  and servers encode/decode the same JSON without each re-declaring (and drifting
  on) the shapes.
- Depend on nothing but Foundation, and build on every platform an MCP consumer
  runs on (macOS, iOS, Linux). The dependency must be trivial to take on.
- Match the MCP specification's JSON exactly (`protocolVersion` `2025-11-25`), so a
  consumer can wire-talk to any compliant peer.

## Non-goals

- No transport. A consumer adds its own under its own sub-namespace (for example
  `extension MCP.Core { enum Transport {} }`). The wire core stays transport-blind.
- No server runtime, no client, no behaviour beyond `Codable`.
- No vendor-specific types (for example, a server's own icon/branding type stays in
  that server, not here).

## Shape

- One target/product: `SwiftMCPCore`.
- Types live under `MCP.Core.Protocols.*` (the anchor cannot be `MCP.Core.Protocol`
  because Swift reserves `.Protocol` as a metatype member). Categories: the JSON-RPC
  base types (RequestID, the JSONRPC* family, the generic Request, AnyCodable,
  JSONValue, ErrorCode), content blocks, tools, resources, prompts, Implementation
  and capabilities, Initialize, Method identifiers, and the protocol version.
- One non-private file-scope type per file; file named for the qualified type
  (`MCP.Core.Protocols.<Name>.swift`).

## The module name

The module is `SwiftMCPCore`, deliberately not `MCPCore`. A consumer that already
owns an `MCPCore` target (a server keeping its transport + runtime there) can
`@_exported import SwiftMCPCore` from that target without a duplicate-module clash.
Because the type anchor is `MCP.Core.Protocols.*` regardless of module name, the
consumer's call sites are unchanged; only its one `import`/`@_exported import` line
references `SwiftMCPCore`.

## Versioning

A change to any type's JSON shape is a breaking change for every consumer; treat it
as such (semver major) and weigh it against the consumer set. Additive wire types
(new MCP methods/results) are minor.
