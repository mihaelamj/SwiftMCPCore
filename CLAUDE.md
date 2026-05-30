# CLAUDE.md

Guidance for Claude Code (and other coding agents) working in this repository.

## Project

SwiftMCPCore is the **neutral, dependency-free wire-protocol core** for the Model
Context Protocol. One Foundation-only, cross-platform module, `SwiftMCPCore`, that
owns the JSON-RPC 2.0 + MCP value types under the `MCP.Core.Protocols.*` namespace.
It is consumed by independent MCP clients and servers (for example
[`SwiftMCPClient`](https://github.com/mihaelamj/SwiftMCPClient) and
the `cupertino` server), which add their own transport and runtime on top.

## Non-negotiables

- **Wire types only.** No transport, no server, no client, no behaviour beyond
  `Codable`. If a change adds anything that is not a wire value type, it does not
  belong here.
- **Foundation only.** Zero non-Foundation dependencies, nothing platform-gated.
  The core must keep building on macOS, iOS, and Linux. This is load-bearing: the
  whole point is a core every MCP consumer can depend on.
- **Spec-faithful JSON.** Type names and JSON field names/shapes follow the MCP
  specification exactly. A wire-shape change is a breaking change; weigh it
  against every consumer.
- **Namespace stays `MCP.Core.Protocols`.** The module is named `SwiftMCPCore`, but
  the type anchor is `MCP.Core.Protocols.*` so consumer call sites are stable. One
  non-private file-scope type per file; file named for the qualified type.
- **Verify before claiming done.** Run `swift build` and `swift test`; cite output.
- **No AI attribution, no em dashes** in any committed text. Enable the hooks:
  `git config core.hooksPath .githooks`.

## Commands

```sh
swift build
swift test
```
