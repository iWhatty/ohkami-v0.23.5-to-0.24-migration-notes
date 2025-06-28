# Hello Example

A slightly larger starter server with logging fangs and two routes:
`/hc` for health checks and `/api` with query and JSON endpoints.  It also shows
how to add custom response headers.

Located in `ohkami-0.24/examples/hello`, this example demonstrates:

- typed responses using [`NoContent`](../../ohkami-0.24/ohkami/src/typed/status.rs)
  for the health check route
- parsing query parameters with [`Query`](../../ohkami-0.24/ohkami/src/format/builtin/query.rs)
- JSON extraction via [`JSON`](../../ohkami-0.24/ohkami/src/format/builtin/json.rs)
- custom middleware with [`FangAction`](../../ohkami-0.24/ohkami/src/fang/middleware/util.rs)
- `SetServer` writes a custom `Server` header via `res.headers.set()`
- `LogRequest` prints the full request using `tracing`

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
