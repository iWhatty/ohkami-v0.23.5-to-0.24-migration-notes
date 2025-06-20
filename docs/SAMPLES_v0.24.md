# Sample Projects

The `samples/` directory contains more complete applications built with Ohkami **v0.24**. They demonstrate advanced features beyond the small
[examples](examples/README.md) folder.

- **petstore** – showcases the `openapi` integration by implementing a minimal Petstore API. Generated OpenAPI JSON and a simple JS client are included.
- **realworld** – partial implementation of the RealWorld spec with JWT authentication and database usage.
- **streaming** – demonstrates streaming responses using Server-Sent Events and WebSocket helpers.
- **worker-with-openapi** – template for deploying to Cloudflare Workers with automatic OpenAPI generation.
- **worker-durable-websocket** – Workers sample using Durable Objects to manage WebSocket sessions.
- **worker-bindings** / **worker-bindings-jsonc** – show the `#[bindings]` macro and JSONC configuration.
- **openapi-tags**, **openapi-schema-enums**, **openapi-schema-from-into** – short programs illustrating OpenAPI tagging and schema derivations.
- **issue_459** – minimal reproduction of a GitHub issue used for regression tests.

Each project has its own `Cargo.toml` and can be run directly. Browse the source under [`ohkami-0.24/samples`](../ohkami-0.24/samples) for details.
