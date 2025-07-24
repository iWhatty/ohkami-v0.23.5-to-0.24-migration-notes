# Runtime Configuration

Ohkami exposes a few environment variables to tweak runtime behavior when
running on a native async runtime.
These options are read at startup and apply to all servers.

- `OHKAMI_REQUEST_BUFSIZE` – maximum size in bytes of the request buffer.
  Defaults to **2048** bytes.
- `OHKAMI_KEEPALIVE_TIMEOUT` – idle connection timeout in seconds before closing.
  Defaults to **30** seconds.
- `OHKAMI_WEBSOCKET_TIMEOUT` – WebSocket session timeout in seconds.
  Defaults to **3600** seconds (1 hour) and only applies with the `ws` feature.

Set each variable before launching the server. They are loaded once when the 
[`CONFIG`](../ohkami-0.24/ohkami/src/config.rs) static initializes so runtime changes are ignored.
These options are only used with native runtimes such as `rt_tokio` or `rt_smol`.

Values are parsed once using `LazyLock`. Invalid or missing variables fall back
to the defaults above. Increase these numbers if clients send large headers or
WebSocket connections should persist longer.

The static [`CONFIG`](../ohkami-0.24/ohkami/src/lib.rs#L171-L176) stores these
values. Each environment variable is parsed in
[`config.rs`](../ohkami-0.24/ohkami/src/config.rs#L33-L61) using
`LazyLock` so the values never change after startup.

Usage in the source:

- `OHKAMI_REQUEST_BUFSIZE` determines the buffer size allocated in
  [`Request::init`](../ohkami-0.24/ohkami/src/request/mod.rs#L186-L204).
  Warnings at
  [lines 266‑281](../ohkami-0.24/ohkami/src/request/mod.rs#L266-L281)
  suggest increasing it if headers exceed the limit.
- `OHKAMI_KEEPALIVE_TIMEOUT` controls the timeout passed to
  [`timeout_in`](../ohkami-0.24/ohkami/src/session/mod.rs#L70-L83)
  when reading each request.
- `OHKAMI_WEBSOCKET_TIMEOUT` sets the duration for WebSocket sessions in
  [`Session::manage`](../ohkami-0.24/ohkami/src/session/mod.rs#L130-L147).
