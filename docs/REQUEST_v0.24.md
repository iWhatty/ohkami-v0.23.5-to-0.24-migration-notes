# HTTP Request Structure

[`Request`](../ohkami-0.24/ohkami/src/request/mod.rs) represents an incoming
HTTP request. It is constructed by the `Session` after parsing the method line
and headers.

Fields include:

- `method: Method` – parsed from the request line.
- `path: Path` – holds the URL path and provides access to parameters.
- `query: QueryParams` – simple key/value map for query strings.
- `headers: RequestHeaders` – parsed header fields with helper methods.
- `payload: Option<CowSlice>` – body bytes if a `Content-Length` is present.
- `context: Context` – per‑request storage for fangs and handlers.
- `ip: std::net::IpAddr` – remote peer address on native runtimes.

The module also defines the
[`FromRequest`](../ohkami-0.24/ohkami/src/request/from_request.rs) trait which
allows extracting custom types from a request. Handlers can accept any number of
`FromRequest` values and the framework handles failures by returning an
appropriate `Response`.

Path parameters implement the separate `FromParam` trait.  Primitive types like
`u32` and `String` are provided out of the box.  Compose them into structs with
`#[derive(FromRequest)]` to conveniently capture multiple pieces of data.

Example fang logging requests:

```rust,no_run
use ohkami::prelude::*;

#[derive(Clone)]
struct Log;
impl FangAction for Log {
    async fn fore<'a>(&'a self, req: &'a mut Request) -> Result<(), Response> {
        println!("{} {}", req.method, req.path.str());
        Ok(())
    }
}
```

See the comments in `request/mod.rs` for additional details on payload limits.
Path parameter parsing is also documented in the source.

## Context and Payload

The request buffer size is configured via the `OHKAMI_REQUEST_BUFSIZE` environment
variable (default **2048** bytes). Payloads are capped by the
[`PAYLOAD_LIMIT`](../ohkami-0.24/ohkami/src/request/mod.rs) constant of
approximately 4&nbsp;GiB. Use `req.payload()` to access the body bytes if present.

`Context` acts as a per‑request key/value store shared between fangs and
handlers. Values are inserted with `.set` and retrieved with `.get`:

```rust,no_run
async fn log_id(req: &mut Request) -> Result<(), Response> {
    req.context.set("user-123".to_string());
    Ok(())
}

async fn handler(req: Request) -> String {
    req.context.get::<String>().cloned().unwrap_or_default()
}
```

When targeting Cloudflare Workers or AWS Lambda additional methods expose the
runtime context:
`context.env()` and `context.worker()` for Workers and `context.lambda()` for
Lambda.

