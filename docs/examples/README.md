# Ohkami Examples

This folder contains short guides for the example projects included with
Ohkami **v0.24**. Each sub‑section explains what the example demonstrates and
how to run it.  If you are new to the framework start with the
[coding guide](../CODING_GUIDE_v0.24.md) and then explore these examples.

- [basic_auth.md](basic_auth.md) – protect a nested app with HTTP Basic auth
- [chatgpt.md](chatgpt.md) – relay questions to OpenAI and stream replies with SSE
- [derive_from_request.md](derive_from_request.md) – implement custom `FromRequest` extractors
- [form.md](form.md) – handle multipart uploads with `Multipart` and `File`
- [hello.md](hello.md) – logging example with typed queries and custom headers
- [html_layout.md](html_layout.md) – server-side rendering using an UIbeam layout
- [json_response.md](json_response.md) – return typed JSON values
- [jwt.md](jwt.md) – issue and validate JWT tokens via the `JWT` fang
- [multiple-single-threads.md](multiple-single-threads.md) – spawn per-core runtimes on one port
- [quick_start.md](quick_start.md) – minimal `/healthz` and `/hello/:name` routes
- [sse.md](sse.md) – stream events using `DataStream`
- [static_files.md](static_files.md) – serve precompressed files with `Dir`
- [websocket.md](websocket.md) – upgrade connections and echo messages
