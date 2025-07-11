# Session Handling

Ohkami processes each network connection through a `Session` struct.
Its implementation lives in
[`ohkami/src/session`](../ohkami-0.24/ohkami/src/session/mod.rs).

A session owns the underlying TCP stream (or other runtime connection type)
and drives the request/response loop. It applies a keep‑alive timeout between
reads and routes each request through the shared `Router`. When the `ws`
feature is enabled a successful upgrade switches the session over to
`WebSocket` management.

The module is compiled only for native runtimes (`__rt_native__`). `Session`
is generic over a connection type implementing `AsyncRead` and `AsyncWrite`.
`TcpStream` provides the default `Connection` implementation which can be
upgraded to a WebSocket when the `ws` feature is enabled.

```rust
pub(crate) struct Session<C> {
    router: Arc<Router>,
    connection: C,
    ip: std::net::IpAddr,
}

pub(crate) trait Connection: AsyncRead + AsyncWrite + Unpin {
    #[cfg(feature = "ws")]
    fn into_websocket_stream(self) -> Result<TcpStream, &'static str>;
}
```

Key behaviors:

- Reads requests with `timeout_in` so idle connections close after
  `OHKAMI_KEEPALIVE_TIMEOUT` seconds.
- Catches panics from handlers and converts them into `500` responses.
- Logs connection errors and broken pipes using macros from
  [`util`](../ohkami-0.24/ohkami/src/util.rs).
- When upgraded to a WebSocket, delegates to `ws::WebSocket` with its own
  timeout (`OHKAMI_WEBSOCKET_TIMEOUT`).
- The request buffer size comes from `OHKAMI_REQUEST_BUFSIZE` which defaults to `2048` bytes.

## Request/Response Loop

`Session::manage` drives the lifetime of each TCP connection. It repeatedly
parses a [`Request`](../ohkami-0.24/ohkami/src/request/mod.rs), routes it to the
handler, sends the resulting [`Response`](../ohkami-0.24/ohkami/src/response/mod.rs)
and continues until the client closes the socket. If the request sets
`Connection: close` the loop exits after that response.

The keep‑alive timer is reset on every successful read. When the timer elapses
`manage` stops reading and the connection is dropped. Response sending uses
`send()` which returns an `Upgrade` enum. If the handler initiated a WebSocket
upgrade, `Session` switches over to the WebSocket manager which applies its own
timeout.

Errors while writing to the socket are printed via `WARNING!` or `ERROR!` and
terminate the session. This helps surface issues such as broken pipes while not
crashing the server process.

The session module is internal but understanding it helps when customizing
runtimes or debugging low‑level behavior.
