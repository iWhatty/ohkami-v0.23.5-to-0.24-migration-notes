# WebSocket Support

With the `ws` feature enabled Ohkami can upgrade HTTP connections to WebSockets.
The [`ws`](../ohkami-0.24/ohkami/src/ws) module defines `WebSocketContext` for
performing the handshake and `WebSocket` as the response type.

```rust
async fn handler(ctx: WebSocketContext<'_>) -> WebSocket {
    ctx.upgrade(|mut conn| async move {
        conn.send("hello").await.expect("send failed");
    })
}
```

Handlers receive a context extracted from the request. Calling `.upgrade` or
`.upgrade_with` returns a `WebSocket` response that completes the handshake and
runs the provided async closure.

On native runtimes connections time out after `OHKAMI_WEBSOCKET_TIMEOUT` seconds
(default 3600).  The returned `Connection` can be split into read and write
halves for concurrent tasks.


