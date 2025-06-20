# Session Handling

Ohkami processes each network connection through a `Session` struct. The implementation lives in [`ohkami/src/session`](../ohkami-0.24/ohkami/src/session/mod.rs).

A session owns the underlying TCP stream (or other runtime connection type) and drives the request/response loop. It applies a keep‑alive timeout between reads and routes each request through the shared `Router`. When the `ws` feature is enabled, a successful upgrade switches the session over to `WebSocket` management.

Key behaviors:

- Reads requests with `timeout_in` so idle connections close after `OHKAMI_KEEPALIVE_TIMEOUT` seconds.
- Catches panics from handlers and converts them into `500` responses.
- Logs connection errors and broken pipes with the utility macros from [`util`](../ohkami-0.24/ohkami/src/util.rs).
- When upgraded to a WebSocket, delegates to `ws::WebSocket` with its own timeout (`OHKAMI_WEBSOCKET_TIMEOUT`).

The session module is internal but understanding it helps when customizing runtimes or debugging low‑level behavior.
