# Hello Example

A slightly larger starter server with logging fangs and two routes:
`/hc` for health checks and `/api` with query and JSON endpoints.  It also shows
how to add custom response headers.

```bash
$ cargo run --example hello
```

Try `curl 'http://localhost:3000/api/query?name=Ohkami&n=2'` to see the repeated
message or send a JSON body to `/api/json`.
