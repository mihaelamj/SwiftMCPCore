# SwiftMCPCore

The neutral, dependency-free **wire-protocol core** for the
[Model Context Protocol](https://modelcontextprotocol.io), in Swift.

One Foundation-only, cross-platform module, **`SwiftMCPCore`**, that owns the
JSON-RPC 2.0 + MCP value types under the `MCP.Core.Protocols.*` namespace:
request/response/error/notification envelopes, `RequestID`, `AnyCodable`,
`JSONValue`, content blocks, tools, resources, prompts, and client/server
capabilities. The type names and JSON shapes follow the MCP specification
(`protocolVersion` `2025-11-25`).

It is **only the wire types**: no transport, no server runtime, no client.
Independent MCP clients and servers depend on this package and add their own
transport and runtime on top. A consumer that already has an `MCPCore` target can
`@_exported import SwiftMCPCore` from it (the module name is intentionally distinct
from `MCPCore` to avoid a duplicate-module clash; the `MCP.Core.Protocols` anchor
is identical regardless, so call sites never change).

## Install

```swift
.package(url: "https://github.com/mihaelamj/SwiftMCPCore.git", from: "0.1.0"),
```

```swift
.target(
    name: "YourMCPThing",
    dependencies: [.product(name: "SwiftMCPCore", package: "SwiftMCPCore")],
)
```

## Use

```swift
import SwiftMCPCore

let request = MCP.Core.Protocols.Request(
    id: .int(1),
    method: "tools/call",
    params: MCP.Core.Protocols.CallToolRequest.Params(name: "list_frameworks", arguments: nil),
)
let data = try JSONEncoder().encode(request)
// ... send `data` over whatever transport you own; decode the response with
//     MCP.Core.Protocols.JSONRPCResponse / JSONRPCError.
```

Add transport in your own namespace, e.g. `extension MCP.Core { enum Transport {} }`;
it deliberately does not live here.

## Requirements

- Swift 6.2+
- Builds on macOS, iOS, and Linux (Foundation-only, zero dependencies).

## Building

```sh
swift build
swift test
```

## License

[MIT](LICENSE).
