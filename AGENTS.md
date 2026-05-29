# Agent Guide

Guidance for anyone (human or coding agent) writing code in swift-mcp-core.

## What this is

The neutral, dependency-free wire-protocol core for the Model Context Protocol: one
Foundation-only, cross-platform module, `SwiftMCPCore`, owning the JSON-RPC 2.0 +
MCP value types under `MCP.Core.Protocols.*`. No transport, no server, no client.
Consumed by independent MCP clients and servers that add their own transport and
runtime. See [docs/DESIGN.md](docs/DESIGN.md) and
[docs/package-import-contract.md](docs/package-import-contract.md).

## Rules

Conventions live in [docs/CONVENTIONS.md](docs/CONVENTIONS.md) and
[docs/rules/](docs/rules/) (start at [docs/rules/README.md](docs/rules/README.md)).
The ones that bite here: Foundation-only (no other imports, ever), cross-platform
(no platform gating), one non-private type per file under the `MCP.Core.Protocols`
namespace, spec-faithful JSON, Swift Testing for tests.

## Workflow

- Verify before claiming done: run `swift build` and `swift test`, cite the output.
- Conventional Commits; a CHANGELOG entry for any change touching shipping source.
- No AI attribution and no em dashes in committed text. Enable the hooks with
  `git config core.hooksPath .githooks`.

## Commands

```sh
swift build
swift test
```
