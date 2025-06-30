# Multiple Single‑Threaded Runtimes

This example runs several single‑threaded Tokio runtimes on the same port. It
scales CPU‑bound services without needing the multi-threaded executor.

Located in [examples/multiple-single-threads](../../ohkami-0.24/examples/multiple-single-threads).

## Files

- `src/main.rs` – sets up the listener and spawns runtimes per CPU core.

### `src/main.rs`

`main` creates a `TcpSocket` with port reuse enabled. It launches a new thread
for each extra CPU core, each running a single-threaded runtime. Every runtime
calls `serve()` which binds to `0.0.0.0:8000` and passes the listener to
`Ohkami::howl`.

```rust
async fn serve(o: Ohkami) -> std::io::Result<()> {
    let socket = tokio::net::TcpSocket::new_v4()?;
    socket.set_reuseport(true)?;
    socket.set_reuseaddr(true)?;
    socket.set_nodelay(true)?;
    socket.bind("0.0.0.0:8000".parse().unwrap())?;
    let listener = socket.listen(1024)?;
    o.howl(listener).await;
    Ok(())
}

for _ in 0..(num_cpus::get() - 1) {
    std::thread::spawn(|| {
        runtime().block_on(serve(ohkami())).expect("serving error");
    });
}
runtime().block_on(serve(ohkami())).expect("serving error");
```

```bash
$ cargo run --example multiple-single-threads
```
