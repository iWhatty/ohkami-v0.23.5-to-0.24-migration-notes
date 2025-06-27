# Quick Start Example

The minimal server used in the README.  It exposes a `/healthz` endpoint and a
parameterized `/hello/:name` route.  This example is a good starting point for
new services.

## Files

- `Cargo.toml` – declares the `ohkami` dependency.
- `src/main.rs` – implements the handlers and server setup.


### `src/main.rs`

- `health_check` – returns a `NoContent` status for `/healthz`.
- `hello` – greets the captured name from `/hello/:name`.
- `main` builds an `Ohkami` instance with the two routes and listens on
  `localhost:3000`.

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
    ))
    .howl("localhost:3000").await
}
```

See [`src/main.rs`](../../ohkami-0.24/examples/quick_start/src/main.rs) for the
complete file.

```bash
$ cargo run --example quick_start
```
