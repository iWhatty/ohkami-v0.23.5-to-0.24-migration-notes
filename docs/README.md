# Ohkami v0.24 Documentation

This directory collects learning material for the
[Ohkami](https://github.com/ohkami-rs/ohkami) web framework.
Use these guides when exploring version **0.24**.

For a quick project overview, see the main
[README](../ohkami-0.24/README.md) in the source tree.

- [STARTUP_GUIDE_v0.24.md](STARTUP_GUIDE_v0.24.md) — installation, basic routing and TLS setup.
- [CODING_GUIDE_v0.24.md](CODING_GUIDE_v0.24.md) — walkthrough of common APIs and patterns.
- [CODE_STYLE_v0.24.md](CODE_STYLE_v0.24.md) — conventions used throughout the code base.
- [PRELUDE_v0.24.md](PRELUDE_v0.24.md) — common re‑exports and runtime helpers.
- [PATTERNS_v0.24.md](PATTERNS_v0.24.md) — idioms for nesting, dependency injection,
  typed errors and custom path parameters.
- [ARCHITECTURE_v0.24.md](ARCHITECTURE_v0.24.md) — crate layout and runtime abstraction.
- [SESSION_v0.24.md](SESSION_v0.24.md) — how connections are managed,
  including the `Connection` trait, timeout control and the `OHKAMI_REQUEST_BUFSIZE` setting.
- [RUNTIME_ADAPTERS_v0.24.md](RUNTIME_ADAPTERS_v0.24.md) — deploying to
  Workers or Lambda with examples, including Lambda WebSocket support.
- [UTILS_v0.24.md](UTILS_v0.24.md) — helper functions like base64 encoding,
  cookie parsing and `timeout_in` plus streaming helpers such as `stream::queue`
  and `stream::once` with `StreamExt` combinators. Covers slice, num and time
  modules too, and notes the `num_cpus` re-export for glommio runtimes.
- [MACROS_v0.24.md](MACROS_v0.24.md) — derives plus OpenAPI macros and Workers
  helpers. Describes `#[bindings(env)]` and worker metadata options for
  automatic documentation.
 - [FANGS_v0.24.md](FANGS_v0.24.md) — overview of builtin middleware and
   configuration options. Notes that `CORS` automatically selects allowed
   methods based on the defined routes and that `BasicAuth` and `JWT`
   integrate with OpenAPI security schemes.
- [FORMAT_v0.24.md](FORMAT_v0.24.md) — request/response body helpers and custom format examples.
- [HEADERS_v0.24.md](HEADERS_v0.24.md) — common header utilities with `QValue`,
  cookie iteration, `ETag` parsing and comparison helpers, compression helpers
  including `CompressionEncoding::to_extension`, plus `SetCookie` builder
  methods and `AcceptEncoding::parse` behavior.
- [DIR_v0.24.md](DIR_v0.24.md) — static directory fang with preloading,
  compression and caching details. With the `openapi` feature enabled
  these files appear in the generated spec as `GET` operations.
- [REQUEST_v0.24.md](REQUEST_v0.24.md) — request structure, context store and extraction.
- [RESPONSE_v0.24.md](RESPONSE_v0.24.md) — building responses.
- [ERROR_HANDLING_v0.24.md](ERROR_HANDLING_v0.24.md) — custom error enums and
  the `IntoResponse` trait.
- [TYPED_v0.24.md](TYPED_v0.24.md) — typed statuses and headers.
- [OPENAPI_v0.24.md](OPENAPI_v0.24.md) — macros and `Ohkami::generate` for
  automatic OpenAPI documentation.
- [TLS_v0.24.md](TLS_v0.24.md) — HTTPS support via `rustls` using `howls` with a
  certificate loading example.
- [TESTING_v0.24.md](TESTING_v0.24.md) — debug-only in-memory harness for calling routes,
  `TestRequest` builders for query, header and JSON bodies, and `TestResponse`
  helpers for inspecting headers and content.
- [WS_v0.24.md](WS_v0.24.md) — upgrading connections to WebSockets with
  Workers and Lambda adapters.
- [SSE_v0.24.md](SSE_v0.24.md) — streaming Server‑Sent Events with the
  `DataStream` queue and custom `Data` types. Includes implementation notes
  describing how the queue interacts with `Response`.
- [ROUTER_v0.24.md](ROUTER_v0.24.md) — how routes are organized and finalized.
- [FEATURE_FLAGS_v0.24.md](FEATURE_FLAGS_v0.24.md) — optional Cargo features
  detailing runtime and protocol flags.
- [TASKS_v0.24.md](TASKS_v0.24.md) — explains the Taskfile runtime matrix,
  nightly feature detection, benchmark gating and tips for targeting a single
  runtime with `--rt`.
- [BENCHES_v0.24.md](BENCHES_v0.24.md) — micro and runtime benchmarks with tuning tips,
  sample results and comparisons of header containers and `TupleMap` lookups.
  including header container and `TupleMap` comparisons.

- [CONFIGURATION_v0.24.md](CONFIGURATION_v0.24.md) — environment variables with
  source links explaining how each value is used.
- [DOCS_ROADMAP.md](DOCS_ROADMAP.md) — what parts of the source have been documented so far.
- [DOCS_TODO_v0.24.md](DOCS_TODO_v0.24.md) — checklist for verifying each guide.
- [FEATURE_REQUESTS.md](FEATURE_REQUESTS.md) — ideas for future improvements.
- [examples/](examples/README.md) — documentation for the example projects.
  - [quick_start.md](examples/quick_start.md) — minimal starter server.
  - [json_response.md](examples/json_response.md) — typed `JSON` wrapper usage.
  - [basic_auth.md](examples/basic_auth.md) — protecting routes with HTTP Basic authentication.
  - [jwt.md](examples/jwt.md) — issuing and validating tokens with the `JWT` fang.
  - [derive_from_request.md](examples/derive_from_request.md) — custom `FromRequest` traits.
  - [multiple-single-threads.md](examples/multiple-single-threads.md) — spawn per-core runtimes
    on a shared port.
  - [form.md](examples/form.md) — multipart uploads with `Multipart` and `File`.
  - [hello.md](examples/hello.md) — starter server with logging and custom headers.
  - [chatgpt.md](examples/chatgpt.md) — relay ChatGPT responses using SSE.
  - [sse.md](examples/sse.md) — streaming events with `DataStream`.
  - [static_files.md](examples/static_files.md) — directory serving with
    compression and caching.
  - [html_layout.md](examples/html_layout.md) — wrapping responses with a UIbeam layout.
  - [websocket.md](examples/websocket.md) — echo patterns, connection splitting
    and Lambda integration.
- [SAMPLES_v0.24.md](SAMPLES_v0.24.md) — overview of the sample projects with Workers templates.
- [NOTES_FROM_SOURCE_v0.24.md](NOTES_FROM_SOURCE_v0.24.md) - design notes: router and Dir.
- [../ENV_SETUP.md](../ENV_SETUP.md) — initializing the workspace environment.
