# Prelude Module

The [`prelude`](../ohkami-0.24/ohkami/src/lib.rs) collects the most frequently
used pieces of the framework.  By importing `ohkami::prelude::*` examples can
stay concise without a long list of `use` statements.

## What it Contains

- `Request`, `Response`, `IntoResponse`, `Method` and `Status` –
  core HTTP types.
- [`FangAction`](../ohkami-0.24/ohkami/src/util.rs) – trait for building and
  chaining middleware.
- `Serialize` and `Deserialize` derives from
  [`ohkami_macros`](../ohkami-0.24/ohkami_macros/src/lib.rs).  These mirror the
  `serde` macros so you do not need to depend on `serde` directly.
- Format helpers [`JSON`] and [`Query`](../ohkami-0.24/ohkami/src/format) for
  request extraction and response bodies.
- [`Context`](../ohkami-0.24/ohkami/src/fang/builtin/context.rs) – typed storage
  available inside a request for fangs and handlers.
- `Route` and `Ohkami` when a runtime feature (e.g. `rt_tokio`) is enabled,
  letting you construct routers and launch the server.

## Example

```rust
use ohkami::prelude::*;

async fn hello() -> Response {
    JSON("hi").into_response()
}

#[tokio::main]
async fn main() {
    Ohkami::new(("/".GET(hello))).howl("localhost:3000").await;
}
```

Importing from the prelude is optional.  You can use the individual paths if you
prefer explicit imports.
