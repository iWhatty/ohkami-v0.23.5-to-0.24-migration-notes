# Basic Auth Example

Demonstrates guarding a nested Ohkami tree with HTTP Basic authentication. A
`BasicAuth` fang protects the inner application while the outer server keeps a
public `/hello` route available.

## Files

- `src/main.rs` – sets up the credentials and routers.

### `src/main.rs`

```rust
use ohkami::prelude::*;
use ohkami::fang::BasicAuth;

#[tokio::main]
async fn main() {
    let private_ohkami = Ohkami::new((
        BasicAuth {
            username: "master of hello",
            password: "world"
        },
        "/hello".GET(|| async {"Hello, private :)"})
    ));

    Ohkami::new((
        "/hello".GET(|| async {"Hello, public!"}),
        "/private".By(private_ohkami)
    )).howl("localhost:8888").await
}
```

See [`src/main.rs`](../../ohkami-0.24/examples/basic_auth/src/main.rs) for the
full file.

Run it with:

```bash
cargo run -p basic_auth
```

Then access `http://localhost:8888/hello` for the public route or
`http://localhost:8888/private/hello` with the credentials `master of hello` /
`world`. Avoid Basic Auth over plain HTTP; use HTTPS in production.
