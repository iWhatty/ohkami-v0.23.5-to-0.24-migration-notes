# Procedural Macros

The `ohkami_macros` crate implements several derive and attribute macros used throughout Ohkami.
Source code lives under [`ohkami_macros/src`](../ohkami-0.24/ohkami_macros/src).

## Serialization Helpers

`Serialize` and `Deserialize` are thin wrappers over the `serde` derives. They
let you use serialization without adding `serde` to your own `Cargo.toml`.

## Request Extraction

`#[derive(FromRequest)]` generates implementations for extracting typed data from
an incoming `Request`. Structs composed of other `FromRequest` types can be
derived to gather multiple parameters at once.

```rust
use ohkami::prelude::*;

#[derive(FromRequest)]
struct Params<'r> {
    Method: Method,
    Path:   &'r str,
}

async fn handler(Params { Method, Path }: Params<'_>) -> String {
    format!("{Method:?} {Path}")
}
```

## OpenAPI Integration

With the `openapi` feature enabled, `#[derive(Schema)]` and the `#[operation]`
attribute generate OpenAPI schemas and operation metadata from your types and
handler functions.

```rust
use ohkami::prelude::*;
use ohkami::openapi;

#[derive(Serialize, openapi::Schema)]
struct User { id: usize, name: String }

#[openapi::operation({ summary: "list users" })]
async fn list_users() -> JSON<Vec<User>> { JSON(vec![]) }
```

## Cloudflare Workers Support

When targeting Workers the `worker` attribute connects an async function as the
entry point. `DurableObject` marks a struct for use with Workers durable
objects. These rely on the `worker` runtime crate.

`#[bindings]` reads your `wrangler.toml` and generates a struct containing Cloudflare
environment bindings.  This removes boilerplate when accessing KV stores or other
resources from Workers code.

```rust
#[ohkami::bindings]
struct Bindings;

#[ohkami::worker]
pub fn app() -> Ohkami {
    Ohkami::new(("/".GET(|| async {"hi"})))
}

#[DurableObject]
struct Room {
    state: worker::State,
}
```

`#[DurableObject]` binds the struct to the Workers runtime so methods like
`fetch` and `websocket_message` can be implemented.

The internal `consume_struct` macro is used by some derives and generally is not
needed directly by applications.

These macros reduce boilerplate and keep your application code focused on business logic.

