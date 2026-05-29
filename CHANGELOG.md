# Changelog

All notable changes to swift-mcp-core are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `SwiftMCPCore`: the Foundation-only, cross-platform MCP wire-protocol core under
  the `MCP.Core.Protocols` namespace. JSON-RPC 2.0 base types (RequestID, the
  JSONRPCRequest / Notification / Response / Error family with ErrorDetail, the
  generic Request, ErrorCode, JSONValue, AnyCodable); content blocks (ContentBlock
  with TextContent / ImageContent / EmbeddedResource, ResourceContents with
  Text / Blob); tools (Tool, JSONSchema, the list/call requests and results,
  CallToolResult); resources (Resource, ResourceTemplate, the list/read/subscribe
  requests and results); prompts (Prompt, PromptArgument, PromptMessage with its
  Role, the list/get requests and results, the list-changed notification);
  Implementation and Icon; client and server capabilities; Initialize types;
  Method identifiers; EmptyParams; and `MCPProtocolVersion` (`2025-11-25`).
  Extracted verbatim from CupertinoMCPClientKit's wire core.
