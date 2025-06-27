# Feature Flags

Ohkami exposes a variety of optional Cargo features. They control which runtime
adapter and protocol helpers are compiled. Enable the flags that match your
deployment environment.

## Runtime selection

- `rt_tokio`, `rt_smol`, `rt_nio`, `rt_glommio` – run on a native async runtime.
- `rt_worker` – compile to WebAssembly for Cloudflare Workers and unlock the
  `#[bindings]` macro and `ws::SessionMap` helper.
- `rt_lambda` – experimental support for AWS Lambda.

Only one runtime should be selected at a time.

## Protocols

- `sse` – enable Server‑Sent Events via `DataStream`.
- `ws` – enable WebSocket helpers for connection upgrades.
- `openapi` – generate an `openapi.json` from route definitions. On Workers use
  [`scripts/workers_openapi.js`](../ohkami-0.24/scripts/workers_openapi.js) to
  run generation outside the `wasm32` environment.
- `tls` – HTTPS support using `rustls` (requires `rt_tokio`).
- `nightly` – nightly only features and optimizations.

## Debugging

- `DEBUG` – extra logging and test helpers; enabled automatically for examples
  and the test suite.

See the [README](../ohkami-0.24/README.md#feature-flags) for a detailed
walkthrough of each flag and example usage.
