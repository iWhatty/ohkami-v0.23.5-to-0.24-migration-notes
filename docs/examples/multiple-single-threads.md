# Multiple Single‑Threaded Runtimes

Starts several single‑threaded Tokio runtimes listening on the same port.
Useful for scaling CPU‑bound servers without a full multi‑threaded executor.

## Files

- `src/main.rs` – spawns multiple single-threaded Tokio runtimes.

### `src/main.rs`

`ohkami()` defines a tiny app with one route. The `main` function builds a TCP
listener with port reuse enabled and then starts several runtimes, each calling
`serve()` to accept connections on the same port.

```bash
$ cargo run --example multiple-single-threads
```
