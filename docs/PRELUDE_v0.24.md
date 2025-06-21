# Prelude Module

The [`prelude`](../ohkami-0.24/ohkami/src/lib.rs) re-exports the most common
traits and types so examples can simply `use ohkami::prelude::*`.
This keeps boilerplate low when writing handlers.

## What it Contains

- `Request`, `Response`, `IntoResponse`, `Method` and `Status`
- [`FangAction`](../ohkami-0.24/ohkami/src/util.rs) for middleware control
- The `Serialize` and `Deserialize` derives from `ohkami_macros`
- Format helpers like [`JSON`] and [`Query`](../ohkami-0.24/ohkami/src/format)
- `Context` for fangs
- `Route` and `Ohkami` when a runtime feature is active

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

The prelude is optional; you can import items individually if you prefer explicit paths.
