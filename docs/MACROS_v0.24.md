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

`#[operation]` accepts an optional identifier to override the default
`operationId` plus a block of metadata fields such as `summary` and
`requestBody` descriptions.  Responses can be described using status code keys.
See [`openapi.rs`](../ohkami-0.24/ohkami_macros/src/openapi.rs) for all
supported keywords.

## Cloudflare Workers Support

When targeting Workers the `worker` attribute connects an async function as the
entry point. `DurableObject` marks a struct for use with Workers durable
objects. These rely on the `worker` runtime crate.

`#[worker]` can optionally receive metadata used when generating an OpenAPI
document.  Fields like `title`, `version` and `servers` default to values read
from `package.json` and your `wrangler.toml`.  You only need to specify them to
override the defaults:

```rust
#[ohkami::worker({ title: "chat", version: 1 })]
async fn app() -> Ohkami { /* ... */ }
```

`#[bindings]` reads your `wrangler.toml` and generates a struct containing Cloudflare
environment bindings.  This removes boilerplate when accessing KV stores or other
resources from Workers code.

Pass an environment name such as `dev` to load bindings from that section of the
configuration:

```rust
#[ohkami::bindings(dev)]
struct DevBindings;
```

The generated struct implements `FromRequest` and exposes constants for any
`vars` values so you can pull the bindings from a worker `Env` or use them
directly. Auto binding mode collects all bindings for a unit struct while manual
mode maps fields by name. Supported types include AI, KV, R2, D1, Queue
(producer), Service and Durable Objects.

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
`fetch` and `websocket_message` can be implemented.  Pass `fetch`, `alarm` or
`websocket` to select the generated wrapper for that use case.

The internal `consume_struct` macro is used by some derives and generally is not
needed directly by applications.

These macros reduce boilerplate and keep your application code focused on business logic.

