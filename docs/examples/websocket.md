# WebSocket Echo Examples

Several echo servers showcasing different ways to use WebSockets in Ohkami.
`/echo1` upgrades directly, `/echo2` wraps the upgrade in a custom type and
`/echo3` demonstrates splitting the connection.  Static HTML templates are served
from `template/` for testing with a browser.

The server installs a `Logger` fang and uses the `Dir` fang to serve the
browser client. Each handler receives a `WebSocketContext` and either upgrades
the connection or returns a type that does.

## Files

- `src/main.rs` – contains four echo handlers and mounts the routes.
- `template/index.html` – simple browser client for manual testing.

### `src/main.rs`

Each handler shows a different upgrade pattern:

- `echo_text` – direct upgrade, sending back each received text frame.
- `echo_text_2` – returns a type implementing `IntoResponse` for deferred upgrade.
- `echo_text_3` – splits the socket and spawns tasks to manage read/write.
- `echo4` – demonstrates spawning without awaiting the join handle.

```rust,ignore
Ohkami::new((Logger,
    "/".Dir("./template").omit_extensions([".html"]),
    "/echo1".GET(echo_text),
    "/echo2/:name".GET(echo_text_2),
    "/echo3/:name".GET(echo_text_3),
    "/echo4/:name".GET(echo4),
))
```

```bash
$ cargo run --example websocket
```

## AWS Lambda

Ohkami can also handle API Gateway WebSocket events using `LambdaWebSocket`.
Compile with the `rt_lambda` and `ws` features and pass a handler to
`LambdaWebSocket::handle`:

```rust,no_run
use ohkami::{LambdaWebSocket, LambdaWebSocketMESSAGE};

#[ohkami::lambda]
async fn main() -> Result<(), lambda_runtime::Error> {
    lambda_runtime::run(LambdaWebSocket::handle(echo)).await
}

async fn echo(
    mut ws: LambdaWebSocket<LambdaWebSocketMESSAGE>
) -> Result<(), lambda_runtime::Error> {
    ws.send(ws.event).await?;
    ws.close().await?;
    Ok(())
}
```

Implementation details live in
[`x_lambda.rs`](../../ohkami-0.24/ohkami/src/x_lambda.rs).
