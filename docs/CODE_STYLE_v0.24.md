# Ohkami Code Style

This guide summarizes common conventions seen in the `ohkami` source
and examples for v0.24.  Following these patterns will keep your
handlers and modules consistent with the official repository.

## Imports via Prelude

Most examples start with `use ohkami::prelude::*;`.  The
[prelude](../ohkami-0.24/ohkami/src/lib.rs) re‑exports common types such
as `Request`, `Response`, `Route` and `FangAction` so you can keep the
import list short.

```rust
use ohkami::prelude::*;
use ohkami::typed::status;
```

Explicit module paths work as well but the prelude keeps code concise.

## Modules

Large examples group related handlers inside modules.  The
`hello` example is a good template:

```rust
mod health_handler {
    use ohkami::typed::status::NoContent;

    pub async fn health_check() -> NoContent {
        NoContent
    }
}

mod hello_handler {
    use ohkami::format::{Query, JSON};
    use ohkami::serde::Deserialize;
    // ...
}
```

Handlers are defined in their own modules and imported in `main` when
constructing the `Ohkami` instance.

## Routing Syntax

Paths are plain string literals implementing the
[`Route`](../ohkami-0.24/ohkami/src/ohkami/routing.rs) trait.  Chain the
HTTP method you want to map to its handler.

```rust
Ohkami::new((
    "/".GET(index),
    "/api/users/:id".PATCH(update_user),
));
```

Use `.By(other)` to delegate an entire sub‑router and `.Dir(path)` to
serve static files on native runtimes.

## Fangs

Middleware implementations are called *fangs*.  A fang implements the
`FangAction` trait.  The `hello` example defines `SetServer` and
`LogRequest`:

```rust
#[derive(Clone)]
pub struct SetServer;
impl FangAction for SetServer {
    fn back<'a>(&'a self, res: &'a mut Response)
        -> impl std::future::Future<Output = ()> + Send
    {
        res.headers.set().Server("ohkami");
        async {}
    }
}
```

Fangs are added in the routing tuple before the path definitions.

### Builtin Fangs

The [`fang::builtin`](../ohkami-0.24/ohkami/src/fang/builtin) module
provides ready made middleware:

- `Context` – store request scoped values.
- `BasicAuth` – HTTP Basic authentication.
- `JWT` – token based auth.
- `CORS` – Cross‑Origin Resource Sharing headers.
- `Timeout` – cancel slow requests on native runtimes.

## Handler Functions

Handlers are asynchronous functions returning a type that implements
`IntoResponse`.  The project sources document the signature rules
explicitly:

```text
async ({path params}?, {FromRequest<'_> types}...) -> {IntoResponse type}
```

Handlers must be `Send` and `Sync` on native runtimes.  Parameter types
implement `FromParam` or `FromRequest` as needed.

## Typed Statuses

HTTP status helpers are generated as types.  For example the
`typed/status.rs` module defines constructors like `Created` and
`NoContent`:

```rust
pub fn Created<B: IntoBody>(body: B) -> Created<B> { ... }
```

Use these instead of manual `Response` building to keep responses
uniform and self documenting.  The generated types automatically set
`Content-Type` and `Content-Length` headers based on the body so your
handlers remain minimal.
