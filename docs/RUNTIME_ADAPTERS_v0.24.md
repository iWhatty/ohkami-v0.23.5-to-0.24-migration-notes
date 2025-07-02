# Cloud Runtime Adapters

Ohkami can run inside serverless environments through optional adapters. These
live in [`x_worker.rs`](../ohkami-0.24/ohkami/src/x_worker.rs) and
[`x_lambda.rs`](../ohkami-0.24/ohkami/src/x_lambda.rs).

## Cloudflare Workers

Enabling the `rt_worker` feature exposes utilities for the
[workers-rs](https://github.com/cloudflare/workers-rs) runtime:

 - Procedural macros `#[worker]` and `#[DurableObject]` connect Ohkami routes to
   Cloudflare entry points.
 - The `FromEnv` trait lets you extract bindings (KV stores, queues, etc.) from
   the worker environment.
 - Durable Objects implement a trait with async hooks like `fetch`,
   `websocket_message`, and `alarm`.

`#[bindings]` can generate a struct with fields for bindings defined in your
`wrangler.toml` so you can access them via the `worker` crate without manual
boilerplate. All three macros live in the
[`ohkami_macros`](../ohkami-0.24/ohkami_macros/src) crate.

```rust
#[ohkami::bindings]
struct Bindings;

#[ohkami::worker]
async fn app() -> ohkami::Ohkami {
    Ohkami::new(("/".GET(|| async { "hi" })))
}
```

Add an environment name like `dev` to pull bindings from that section of your
configuration:

```rust
#[ohkami::bindings(dev)]
struct DevBindings;
```

The generated struct implements `FromRequest` so handlers can receive it
directly.

See the inline examples in `x_worker.rs` for a full setup.

## AWS Lambda

When built with the `rt_lambda` feature Ohkami integrates with
`lambda_runtime` through types in `x_lambda.rs`.
It defines `LambdaHTTPRequest` and `LambdaResponse` structs compatible with API
Gateway and provides a basic WebSocket client for AWS' WebSocket APIs.
`Ohkami` implements `lambda_runtime::Service`, so you simply pass an instance to
`lambda_runtime::run`:

```rust
#[tokio::main]
async fn main() -> Result<(), lambda_runtime::Error> {
    lambda_runtime::run(my_ohkami()).await
}
```

With the `ws` feature enabled you can handle API Gateway WebSocket events using
`LambdaWebSocket::handle`. This helper adapts an async function into a
`lambda_runtime::Service` that receives a `LambdaWebSocket` instance. The type
wraps the connection context and exposes `send` and `close` methods.

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

An adapter to map between generic Lambda events and Ohkami `Request`/`Response`
types is still planned but not yet finalized.

These modules let you deploy the same application logic to native servers or
serverless platforms with minimal changes.
