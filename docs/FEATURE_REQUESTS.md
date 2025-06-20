# Feature Requests

This document lists desired improvements or missing pieces discovered while reviewing the Ohkami **v0.24** source.
They are candidates for future work.

- **HTTP/2 and HTTP/3 servers** – currently only HTTP/1.1 is implemented. Native support for newer protocols would improve performance and compatibility.
- **AWS Lambda WebSocket support** – the `rt_lambda` adapter handles HTTP but WebSocket handling is marked TODO. Implementing this would allow real‑time features on Lambda.
- **OpenAPI generation on Workers** – Cloudflare Workers cannot write files directly. A dedicated CLI or API to generate the document without node scripts would streamline deployment.
- **Safer handler conversion** – `fang::handler::into_handler` uses `unsafe` to transmute lifetimes. Refactoring this to avoid `unsafe` would increase reliability.
- **Additional runtime TLS options** – TLS currently only works with the Tokio runtime. Support for `smol` or others would help more environments.

Community feedback and pull requests are welcome!
