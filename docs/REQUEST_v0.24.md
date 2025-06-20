# HTTP Request Structure

[`Request`](../ohkami-0.24/ohkami/src/request/mod.rs) represents an incoming HTTP request. It is constructed by the `Session` after parsing the method line and headers.

Fields include:

- `method: Method` – parsed from the request line.
- `path: Path` – holds the URL path and provides access to parameters.
- `query: QueryParams` – simple key/value map for query strings.
- `headers: RequestHeaders` – parsed header fields with helper methods.
- `payload: Option<CowSlice>` – body bytes if a `Content-Length` is present.
- `context: Context` – per‑request storage for fangs and handlers.
- `ip: std::net::IpAddr` – remote peer address on native runtimes.

The module also defines the [`FromRequest`](../ohkami-0.24/ohkami/src/request/from_request.rs) trait which allows extracting custom types from a request. Handlers can accept any number of `FromRequest` values and the framework handles failures by returning an appropriate `Response`.

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

See the comments in `request/mod.rs` for additional details on payload limits and path parameter parsing.
