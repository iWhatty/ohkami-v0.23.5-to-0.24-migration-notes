# Quick Start Example

The minimal server used in the README.  Includes a health check endpoint and
parameterized hello route.  Perfect as a template for new services.

## Files

- `Cargo.toml` – declares the `ohkami` dependency.
- `src/main.rs` – implements the handlers and server setup.

### `src/main.rs`

- `health_check` – returns a `NoContent` status for `/healthz`.
- `hello` – greets the path parameter captured from `/hello/:name`.
- the `main` function builds an `Ohkami` instance with the two routes and
  listens on `localhost:3000`.

```bash
$ cargo run --example quick_start
```
