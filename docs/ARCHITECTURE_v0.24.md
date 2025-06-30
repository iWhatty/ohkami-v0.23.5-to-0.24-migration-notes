# Ohkami v0.24 Architecture

This guide explains how the framework is organized so you can quickly locate
modules in the source tree.

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

The workspace also contains `ohkami_macros` for procedural macros,
`ohkami_lib` with lightweight helpers and `ohkami_openapi` for specification generation.

### Runtime Abstraction

A private `__rt__` module hides the differences between async runtimes.
It re‑exports `TcpListener`, `TcpStream` and common I/O traits based on the
selected `rt_*` feature so the rest of the crate can stay runtime agnostic.

## Request Flow

Each server connection is wrapped in a [`Session`](../ohkami-0.24/ohkami/src/session/mod.rs).
It reads the request using the timeouts and buffer sizes from
[`config.rs`](../ohkami-0.24/ohkami/src/config.rs). The parsed
[`Request`](../ohkami-0.24/ohkami/src/request/mod.rs) is routed to a handler
and its associated *fangs*. After the handler finishes, a
[`Response`](../ohkami-0.24/ohkami/src/response/mod.rs) is written back to the
client.

Optional features extend this flow:

- `ws` upgrades a request to a WebSocket handled by
  [`ws::WebSocket`](../ohkami-0.24/ohkami/src/ws).
- `sse` streams events using [`sse::DataStream`](../ohkami-0.24/ohkami/src/sse).
- `tls` wraps the TCP stream in a
  [`TlsStream`](../ohkami-0.24/ohkami/src/tls/mod.rs).
- `openapi` generates documentation via `ohkami_openapi`.

Understanding this layout helps navigate the codebase and customize pieces for
your own projects.
