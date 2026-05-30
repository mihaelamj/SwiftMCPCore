# Per-target import contract

One row per target. The allowed column is exhaustive: anything beyond it is a
violation. `Foundation` and the test framework (`Testing`) are ambient and not
counted.

| Target | Allowed imports | State |
|---|---|---|
| `SwiftMCPCore` | (Foundation only) | ✅ |
| `SwiftMCPCoreTests` | `SwiftMCPCore` | ✅ |

## Notes

- **`SwiftMCPCore` is Foundation-only by construction.** Zero non-Foundation
  dependencies, nothing platform-gated. This is the entire point of the package: a
  wire core every MCP consumer can depend on, on every platform. Adding any other
  import is the highest-severity violation here and must be rejected.
- There is deliberately no transport, server, or client target. Those belong in the
  consumers, not in the shared wire core.
