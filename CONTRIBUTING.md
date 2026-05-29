# Contributing to swift-mcp-core

Thanks for your interest. This guide covers how to set up, the conventions the
project follows, and how to land a change.

By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## Language policy

This is a **Swift** project. All code is Swift, no exceptions: no JavaScript, no
build-step scripting beyond the shell gates in `scripts/`.

## What this is

The neutral, dependency-free MCP wire-protocol core: one Foundation-only,
cross-platform module (`SwiftMCPCore`) of `Codable` value types under the
`MCP.Core.Protocols.*` namespace. No transport, no server, no client. The
architecture is in [`docs/DESIGN.md`](docs/DESIGN.md).

## Getting started

Requires a recent Swift toolchain (Swift 6.2+). `Package.swift` is at the repo
root:

```sh
swift build
swift test
```

Install the project git hooks once after cloning:

```sh
git config core.hooksPath .githooks
```

This wires three hooks: `commit-msg` and `pre-commit` reject forbidden style
tells (em dashes, tool-attribution) in messages and staged content, and
`pre-push` runs the style, namespacing, format, lint, build, and test gates. The
same gates run in GitHub CI (`.github/workflows/ci.yml`) as the backstop.

## Conventions

Code follows the conventions documented in
[`docs/CONVENTIONS.md`](docs/CONVENTIONS.md). The short version:

- Progressive architecture: simplest thing that works first; add abstraction only
  when a second real consumer exists.
- Every public type lives under a namespace that mirrors its folder; one
  non-private file-scope type per file; file named for the qualified type.
- No force-unwrapping in shipping code; no dependencies beyond Foundation.
- Cross-platform and Foundation-only: the module builds on macOS, iOS, and Linux
  with nothing platform-gated. This is load-bearing; keep it that way.
- Spec-faithful JSON: type names and JSON shapes follow the MCP specification.
- Tests use the Swift Testing framework and pin the on-the-wire shapes.

The per-target import contract is in
[`docs/package-import-contract.md`](docs/package-import-contract.md); a change
that adds an import must keep that table true.

Read the surrounding files before writing new code and match what is already
there. Consistency with existing code outranks personal preference.

## Commits

Commit messages follow Conventional Commits: `<type>(<scope>): summary`, lowercase
type, imperative mood, no trailing period, first line under 72 characters. Types:
`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`,
`chore`.

Do not include AI attribution of any kind, and do not use em dashes in commit
messages. The installed `commit-msg` hook enforces both.

## Branches

Branch from the current tip of `main`:

```sh
git fetch origin main && git checkout -b feat/<topic> origin/main
```

Naming: `fix/<issue>-<topic>`, `feat/<topic>`, `chore/<topic>`, `docs/<topic>`,
`refactor/<topic>`.

## Pull requests

- One focused change per PR. If the diff spans two unrelated concerns, split it.
- Add a `CHANGELOG.md` entry under `Unreleased` for any change that touches
  shipping source. Docs, tests, and config changes do not need an entry.
- Run `swift build` and `swift test` and confirm both pass before opening the PR.
- Do a self-review pass on your own diff and fix what a reviewer would flag.

## License

By contributing, you agree that your contributions are licensed under the
project's [MIT License](LICENSE).
