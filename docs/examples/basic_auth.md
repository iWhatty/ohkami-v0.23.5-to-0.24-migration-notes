# Basic Auth Example

This example shows how to protect a route using HTTP Basic authentication.

It creates a nested `Ohkami` instance secured by the `BasicAuth` fang.  The outer
server exposes a public `/hello` endpoint and a `/private` endpoint that requires
the configured credentials.

## Files

- `src/main.rs` – configures a nested `Ohkami` protected by `BasicAuth`.

### `src/main.rs`

`private_ohkami` defines the secured portion with its own route. The outer
`Ohkami` mounts both the public `/hello` and `/private/hello` which delegates to
the inner application.

Run it with:

```bash
$ cargo run --example basic_auth
```

Then access `http://localhost:8888/hello` for the public route or
`http://localhost:8888/private/hello` with the credentials `master of hello` / `world`.
