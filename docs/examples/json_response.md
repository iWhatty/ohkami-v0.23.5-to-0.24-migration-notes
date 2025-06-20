# JSON Response Example

Simple demonstration of returning typed JSON values.

## Files

- `Cargo.toml` – pulls in `ohkami`.
- `src/main.rs` – implements the handlers.

### `src/main.rs`

Two handlers show how the `JSON` wrapper serializes Rust structs:

- `single_user` – returns one `User` from `/single`.
- `multiple_users` – returns a `Vec<User>` from `/multiple`.

```bash
$ cargo run --example json_response
```

Query `/single` or `/multiple` to see the serialized output.
