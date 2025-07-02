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

### AWS Lambda

When compiled with the `rt_lambda` feature Ohkami exposes a
`LambdaWebSocket` type for handling API Gateway WebSocket events.
Use `LambdaWebSocket::handle` to adapt an async function into a
`lambda_runtime::Service`:

```rust,no_run
use ohkami::{LambdaWebSocket, LambdaWebSocketMESSAGE};
use lambda_runtime::Error;

#[tokio::main]
async fn main() -> Result<(), Error> {
    lambda_runtime::run(LambdaWebSocket::handle(echo)).await
}

async fn echo(mut ws: LambdaWebSocket<LambdaWebSocketMESSAGE>) -> Result<(), Error> {
    ws.send(ws.event).await?;
    ws.close().await?;
    Ok(())
}
```

See [`x_lambda.rs`](../ohkami-0.24/ohkami/src/x_lambda.rs) for details on the
implementation and client used to send responses back through the management
API.

Handlers receive a context extracted from the request. Calling `.upgrade` or
`.upgrade_with` returns a `WebSocket` response that completes the handshake and
runs the provided async closure.

On native runtimes connections time out after `OHKAMI_WEBSOCKET_TIMEOUT` seconds
(default 3600).  The returned `Connection` can be split into read and write
halves for concurrent tasks:

```rust,no_run
let (mut read, mut write) = conn.split();
loop {
    if let Some(Message::Text(t)) = read.recv().await.expect("receive") {
        println!("client -> {t}");
        write.send(t).await.expect("send");
    }
}
```

`WebSocketContext` performs the WebSocket handshake and checks headers like
`Sec-WebSocket-Version`. Use `upgrade_with` to supply a custom configuration from
the underlying `mews` crate if you need control over frame sizes or ping
timeouts.

On Cloudflare Workers the context also exposes `upgrade_durable` and
`upgrade_durable_with`. These helpers connect a WebSocket to a Durable Object
instance and return a `WebSocket` response.
The [`SessionMap`](../ohkami-0.24/ohkami/src/ws/worker.rs)
type can be used inside the object to track active sessions.




Simple echo server:

```rust,no_run
use ohkami::prelude::*;
use ohkami::ws::{WebSocketContext, WebSocket, Message};

async fn echo(ctx: WebSocketContext<'_>) -> WebSocket {
    ctx.upgrade(|mut conn| async move {
        while let Some(msg) = conn.recv().await.expect("recv") {
            if let Message::Text(t) = msg {
                conn.send(t).await.expect("send");
            }
        }
    })
}

#[tokio::main]
async fn main() {
    Ohkami::new(("/ws".GET(echo))).howl("localhost:4040").await;
}
```

### Cloudflare Durable Object

When targeting Workers you may connect a WebSocket to a Durable Object via
`upgrade_durable`:

```rust,no_run
async fn ws_chatroom(ctx: WebSocketContext<'_>, room: worker::Stub)
    -> Result<WebSocket, worker::Error>
{
    ctx.upgrade_durable(room).await
}
```

Inside the object a [`SessionMap`](../ohkami-0.24/ohkami/src/ws/worker.rs)
stores metadata about connected sockets, allowing them to be resumed after
hibernation.

```rust,no_run
use ohkami::ws::SessionMap;

struct Room {
    sessions: SessionMap<Session>,
}

impl Room {
    async fn websocket_message(
        &mut self,
        ws: worker::WebSocket,
        msg: worker::WebSocketIncomingMessage,
    ) -> worker::Result<()> {
        if let Some(session) = self.sessions.get_mut(&ws) {
            // update session based on `msg`
        }
        Ok(())
    }
}
```

