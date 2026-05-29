// swift-tools-version: 6.2
import PackageDescription

// swift-mcp-core: the neutral, dependency-free wire-protocol core for the Model
// Context Protocol. One Foundation-only, cross-platform product (`SwiftMCPCore`)
// that owns the `MCP.Core.Protocols.*` types (JSON-RPC envelopes, content blocks,
// tools, resources, prompts, capabilities). No transport, no server, no client:
// independent MCP clients and servers depend on this and add their own transport
// and runtime on top. Builds on macOS, iOS, and Linux.
//
// The module is named `SwiftMCPCore` (not `MCPCore`) so a consumer that already
// has its own `MCPCore` target can `@_exported import SwiftMCPCore` from it
// without a duplicate-module clash; the `MCP.Core.Protocols` anchor is identical
// regardless, so call sites never change.

let package = Package(
    name: "swift-mcp-core",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(name: "SwiftMCPCore", targets: ["SwiftMCPCore"]),
    ],
    targets: [
        .target(name: "SwiftMCPCore"),
        .testTarget(name: "SwiftMCPCoreTests", dependencies: ["SwiftMCPCore"]),
    ],
)
