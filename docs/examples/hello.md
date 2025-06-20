# Hello Example

A slightly larger starter server with logging fangs and two routes:
`/hc` for health checks and `/api` with query and JSON endpoints.  It also shows
how to add custom response headers.

## Files

- `src/main.rs` – defines the routes and custom fangs used by the example.

### `src/main.rs`

- `health_handler` module – exposes `health_check` for `/hc`.
- `hello_handler` module – provides query and JSON endpoints under `/api`.
- `fangs` module – `LogRequest` and `SetServer` demonstrate custom request/response hooks.
- `main` sets up the `Ohkami` tree combining these pieces and starts the server on `localhost:3000`.

```bash
$ cargo run --example hello
```

Try `curl 'http://localhost:3000/api/query?name=Ohkami&n=2'` to see the repeated
message or send a JSON body to `/api/json`.
