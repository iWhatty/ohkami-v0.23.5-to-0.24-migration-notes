# Hello Example

A slightly larger starter server with logging fangs and two routes:
`/hc` for health checks and `/api` with query and JSON endpoints. It also shows
how to add custom response headers and integrate `tracing` logs.

## Files

- `src/main.rs` – defines the routes and custom fangs used by the example.

### `src/main.rs`

- `health_handler` module – exposes `health_check` which returns
  `status::NoContent` for `/hc`.
- `hello_handler` module – provides `hello_by_query` and `hello_by_json`
  endpoints under `/api`.
- `fangs` module – `LogRequest` logs each request and `SetServer` adds a
  `Server` header to responses.
- `main` sets up the `Ohkami` tree combining these pieces, enables
  `tracing_subscriber`, and starts the server on `localhost:3000`.

```bash
$ cargo run --example hello
```

Try a query request:
```bash
$ curl 'http://localhost:3000/api/query?name=Ohkami&n=2'
```
The JSON endpoint accepts `{ "name": "Ohkami", "repeat": 2 }`:
```bash
$ curl -X POST -H 'Content-Type: application/json' \
  -d '{"name":"Ohkami","repeat":2}' http://localhost:3000/api/json
```
