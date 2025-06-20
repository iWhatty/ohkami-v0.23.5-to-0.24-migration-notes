# Ohkami v0.24 Coding Guide

This guide summarizes the main APIs found in the `ohkami` crate.  It pulls
together examples from the repository and highlights useful patterns to get
you productive quickly.

## Creating an Application

Construct an [`Ohkami`](../ohkami-0.24/ohkami/src/ohkami/mod.rs) by combining
fangs (middleware) and route definitions:

```rust
use ohkami::prelude::*;
use ohkami::typed::status;

async fn health_check() -> status::NoContent {
    status::NoContent
}

async fn hello(name: &str) -> String {
    format!("Hello, {name}!")
}

#[tokio::main]
async fn main() {
    Ohkami::new((
        "/healthz".GET(health_check),
        "/hello/:name".GET(hello),
    )).howl("localhost:3000").await;
}
```

Routes are defined using chained methods on path literals.  Parameters are
captured with `:` prefixes and passed to handlers by type.

## Middleware – *Fangs*

Fangs implement [`FangAction`](../ohkami-0.24/ohkami/src/fang/mod.rs) and can be
registered globally or for individual handlers.  Built‑in fangs live in the
[`fang::builtin`](../ohkami-0.24/ohkami/src/fang/builtin) module and include:

- `Context` – attach request scoped data.
- `BasicAuth` – simple username/password authentication.
- `JWT` – JSON Web Token verification.
- `CORS` – configure Cross‑Origin Resource Sharing headers.
- `Timeout` – abort slow requests on native runtimes.

Custom fangs are normal structs that implement the trait.

```rust
#[derive(Clone)]
struct Log;
impl FangAction for Log {
    async fn fore<'a>(&'a self, req: &'a mut Request) -> Result<(), Response> {
        println!("incoming: {} {}", req.method(), req.path());
        Ok(())
    }
}

Ohkami::new((Log, "/".GET(|| async {"hi"})));
```

## Typed Statuses and Responses

The [`typed::status`](../ohkami-0.24/ohkami/src/typed/status.rs) module generates
types such as `OK`, `Created` and `NoContent`.  Returning these makes handlers
self‑documenting and ensures headers like `Content-Type` and
`Content-Length` are set correctly.

```rust
use ohkami::typed::status;

async fn create() -> status::Created<&'static str> {
    status::Created("done")
}
```

## Testing

Use `ohkami::testing::Test` to invoke routes without opening sockets:

```rust
use ohkami::testing::*;

let t = my_ohkami().test();
let res = t.oneshot(TestRequest::GET("/hello")).await;
assert_eq!(res.status(), Status::OK);
```

## Optional Features

Ohkami exposes optional integrations enabled via Cargo features:

- `openapi` – automatically generate an OpenAPI document with
  [`Ohkami::generate`](../ohkami-0.24/ohkami/src/ohkami/mod.rs).
- `sse` – send Server‑Sent Events using `DataStream`.
- `ws` – handle WebSocket connections through `WebSocketContext`.
- `tls` – serve HTTPS using `howls` with a `rustls` configuration.

Consult the main [README](../ohkami-0.24/README.md) for more details and
example code for each feature.
