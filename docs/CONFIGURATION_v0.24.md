# Runtime Configuration

Ohkami exposes a few environment variables to tweak runtime behavior when running on a native async runtime.
These options are read at startup and apply to all servers.

- `OHKAMI_REQUEST_BUFSIZE` – maximum size in bytes of the request buffer.
  Defaults to **2048** bytes.
- `OHKAMI_KEEPALIVE_TIMEOUT` – idle connection timeout in seconds before closing.
  Defaults to **30** seconds.
- `OHKAMI_WEBSOCKET_TIMEOUT` – WebSocket session timeout in seconds.
  Defaults to **3600** seconds (1 hour) and only applies with the `ws` feature.

Increase these values if clients send large headers or WebSocket connections should persist longer.
