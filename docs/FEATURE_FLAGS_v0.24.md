# Feature Flags

Ohkami exposes several optional Cargo features. These control which runtimes and
protocol helpers are compiled. Enable the features that match your deployment
environment.

## Runtime selection

- `rt_tokio`, `rt_smol`, `rt_nio`, `rt_glommio` – run on a native async runtime.
- `rt_worker` – compile to WebAssembly for Cloudflare Workers.
- `rt_lambda` – experimental support for AWS Lambda.

Only one runtime should be selected at a time.

## Protocols

- `sse` – enable Server‑Sent Events via `DataStream`.
- `ws` – enable WebSocket helpers.
- `openapi` – generate an `openapi.json` from route definitions.
- `tls` – HTTPS support using `rustls`.
- `nightly` – nightly only features and optimizations.

See the [README](../ohkami-0.24/README.md#feature-flags) for a detailed
walkthrough of each flag and example usage.
