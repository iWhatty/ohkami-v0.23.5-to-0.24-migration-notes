# Cloud Runtime Adapters

Ohkami can run inside serverless environments through optional adapters. These live in [`x_worker.rs`](../ohkami-0.24/ohkami/src/x_worker.rs) and [`x_lambda.rs`](../ohkami-0.24/ohkami/src/x_lambda.rs).

## Cloudflare Workers

Enabling the `rt_worker` feature exposes utilities for the [workers-rs](https://github.com/cloudflare/workers-rs) runtime:

- Procedural macros `#[worker]` and `#[DurableObject]` connect Ohkami routes to Cloudflare entry points.
- The `FromEnv` trait lets you extract bindings (KV stores, queues, etc.) from the worker environment.
- Durable Objects implement a trait with async hooks like `fetch`, `websocket_message`, and `alarm`.

See the inline examples in `x_worker.rs` for a full setup.

## AWS Lambda

When built with the `rt_lambda` feature Ohkami integrates with `lambda_runtime` through types in `x_lambda.rs`.
It defines `LambdaHTTPRequest` and `LambdaResponse` structs compatible with API Gateway and provides a basic WebSocket client for AWS' WebSocket APIs. An adapter to map between Lambda events and Ohkami `Request`/`Response` types is planned but not yet finalized.

These modules allow deploying the same application logic to native servers or serverless platforms with minimal changes.
