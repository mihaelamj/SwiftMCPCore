# Security Policy

## Reporting a vulnerability

If you believe you have found a security issue in SwiftMCPCore, please report it
privately. Do not open a public issue for security problems.

Email **mihaelamj@me.com** with:

- A description of the issue and its impact.
- Steps to reproduce, or a proof of concept.
- The affected version or commit.

You can expect an acknowledgement within a few days. Once the issue is confirmed,
a fix will be prepared and a release cut, after which the issue can be disclosed
publicly with credit to the reporter if desired.

## Supported versions

SwiftMCPCore is pre-1.0 and under active development. Security fixes are applied
to the `main` branch. Until a stable release exists, only the latest `main` is
supported.

## Scope

SwiftMCPCore is a pure wire-types library (Foundation-only `Codable` value types
for MCP JSON-RPC). It performs no I/O, spawns no processes, and runs no server. The
in-scope surface is the decoding path: a way that maliciously crafted JSON could
cause a crash, unbounded memory, or other unsafe behaviour when decoded into these
types. Transport and server concerns belong to the consumers, not here.
