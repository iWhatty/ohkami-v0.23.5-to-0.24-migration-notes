# Ohkami v0.24 Architecture

This overview explains how the framework is organized inside the `ohkami` crate so developers know where to look when exploring the source.

## Crate Layout

```
ohkami/
  src/
    config.rs        - runtime configuration from environment
    fang/            - middleware traits and builtins
    format/          - body extractors and serializers
    header/          - helpers for HTTP header values
    ohkami/          - `Ohkami` type and routing utilities
    request/         - parsing HTTP requests
    response/        - building responses
    router/          - tree based router implementation
    session/         - connection handling loop
    sse/             - Server‑Sent Event helpers (feature `sse`)
    tls/             - TLS stream adapter (feature `tls`)
    typed/           - typed status codes and header extraction
    util.rs          - misc utilities used by the framework
    ws/              - WebSocket support (feature `ws`)
    testing/         - in memory test harness
    x_worker.rs      - Cloudflare Workers adapter (feature `rt_worker`)
    x_lambda.rs      - AWS Lambda adapter (feature `rt_lambda`)
```

Additional crates in the workspace include `ohkami_macros` for procedural macros, `ohkami_lib` with lightweight helpers and `ohkami_openapi` for OpenAPI generation.

## Request Flow

Incoming connections are accepted by a runtime specific server. Each socket is wrapped in a `Session` which reads requests using the buffer size and timeouts defined in [`config.rs`](../ohkami-0.24/ohkami/src/config.rs). A parsed [`Request`](../ohkami-0.24/ohkami/src/request/mod.rs) is passed to the router which locates the matching route and any attached *fangs*. Fangs run before and/or after the handler to implement middleware behaviors. The handler returns a [`Response`](../ohkami-0.24/ohkami/src/response/mod.rs) which is written back to the connection.

Optional features extend this flow:

- `ws` upgrades a request to a WebSocket handled by [`ws::WebSocket`](../ohkami-0.24/ohkami/src/ws).
- `sse` streams events using [`sse::DataStream`](../ohkami-0.24/ohkami/src/sse).
- `tls` wraps the TCP stream in a [`TlsStream`](../ohkami-0.24/ohkami/src/tls/mod.rs).
- `openapi` generates documentation via `ohkami_openapi`.

Understanding this structure helps navigate the source code and customize pieces for your own projects.
