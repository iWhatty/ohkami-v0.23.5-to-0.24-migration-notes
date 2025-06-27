# JSON Response Example

Simple demonstration of returning typed JSON values.

## Files

- `Cargo.toml` – pulls in `ohkami`.
- `src/main.rs` – implements the handlers.

### `src/main.rs`

Two handlers show how the `JSON` wrapper serializes Rust structs:

```rust
use ohkami::format::JSON;
use ohkami::serde::Serialize;

#[derive(Serialize)]
struct User {
    id:   u64,
    name: String,
}

async fn single_user() -> JSON<User> { /* ... */ }
async fn multiple_users() -> JSON<Vec<User>> { /* ... */ }
```

See [`src/main.rs`](../../ohkami-0.24/examples/json_response/src/main.rs) for the full file.

```bash
$ cargo run --example json_response
```

Query `/single` or `/multiple` to see the serialized output.
