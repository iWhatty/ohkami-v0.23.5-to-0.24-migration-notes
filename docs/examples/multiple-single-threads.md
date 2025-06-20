# Multiple Single‑Threaded Runtimes

Starts several single‑threaded Tokio runtimes listening on the same port.
Useful for scaling CPU‑bound servers without a full multi‑threaded executor.

```bash
$ cargo run --example multiple-single-threads
```
