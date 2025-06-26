# HTTP Responses

A response is created using the [`response`](../ohkami-0.24/ohkami/src/response)
module. The central [`Response`](../ohkami-0.24/ohkami/src/response/mod.rs) type
is returned from handlers.
A response is composed of a status code, headers and an optional body.

Key pieces:

- `Status` enum – common HTTP status codes with helper constructors.
- `ResponseHeaders` – strongly typed header map with `SetHeaders` builder.
- `Content` enum – body variant used internally (`None`, `Payload`, `Stream`, `WebSocket`).
- `IntoResponse` trait – convert errors or other types into `Response` values.

Typical usage inside a handler:

```rust
use ohkami::{Response, Status};

async fn handler() -> Response {
    Response::new(Status::OK).with_text("Hello")
}
```

Middleware can modify headers by calling `res.headers.set()` in their `back`
method. When the `sse` feature is active a handler may return a streaming body
and the framework handles chunked encoding automatically.

For convenience the `typed::status` module defines constructors like
`status::Created` and `status::NoContent` which return lightweight wrappers
implementing `IntoResponse`.  Prefer these helpers when you simply need to send
a standard status code.

Review the documentation comments in `response/mod.rs` for details on WebSocket and SSE support.

## Building Bodies

`Response` exposes helpers for common content types. `with_text` and `with_html`
set the `Content-Type` header and store the provided string. `with_json`
serializes any `serde::Serialize` value using `serde_json`. For raw bytes use
`with_payload(content_type, bytes)`. When the `sse` feature is active
`with_stream` streams `Data` items as Server‑Sent Events.

The body can be inspected with `payload()` or removed using `drop_content()`.
Calling `without_content()` returns the modified response.

`ResponseHeaders` offers typed setters for standard headers. For example
`res.headers.set().Server("ohkami")` or
`res.headers.set().x("X-Foo", "bar")`.

