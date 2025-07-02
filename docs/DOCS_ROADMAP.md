# Documentation Roadmap

This roadmap tracks coverage of the Ohkami **v0.24** source code in the Markdown guides.
It highlights which modules are documented and notes areas that still need work.

## Well Covered

- `ohkami/src/ohkami` â explained throughout [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md).
- `ohkami/src/fang` â builtin middleware covered in
  [FANGS_v0.24](FANGS_v0.24.md) (builder method details added),
  [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md) and
  [PATTERNS_v0.24](PATTERNS_v0.24.md).
- `ohkami/src/testing` — explained in [TESTING_v0.24](TESTING_v0.24.md).
- `ohkami/src/tls` — usage documented in [TLS_v0.24](TLS_v0.24.md).
- `ohkami/src/request` and `ohkami/src/response` - detailed in
  [REQUEST_v0.24](REQUEST_v0.24.md) (context store and payload limits) and
  [RESPONSE_v0.24](RESPONSE_v0.24.md) (body helpers and typed statuses).
- `ohkami/src/typed` â explained in [TYPED_v0.24](TYPED_v0.24.md).
- `ohkami/src/lib.rs` â crate root documented in the main README.
- `docs/README.md` points back to the crate README so new users can quickly reach
  the latest quick start.
- Module layout overviewed in [ARCHITECTURE_v0.24](ARCHITECTURE_v0.24.md).
- Startup instructions and TLS example covered in [STARTUP_GUIDE_v0.24](STARTUP_GUIDE_v0.24.md).
- `ohkami/src/lib.rs::prelude` — exports documented in [PRELUDE_v0.24](PRELUDE_v0.24.md)
  with notes on runtime gating.
- General conventions such as module layout, prelude imports and routing
  helpers documented in [CODE_STYLE_v0.24](CODE_STYLE_v0.24.md).
- `ohkami/src/ohkami/dir` — static file serving in [DIR_v0.24](DIR_v0.24.md),
 including notes on preloading, compression and cache headers.
- `ohkami/src/config` â environment variables documented in
  [CONFIGURATION_v0.24](CONFIGURATION_v0.24.md). Values are loaded once at
  startup through the [`CONFIG`](../ohkami-0.24/ohkami/src/config.rs) static.
- `ohkami/src/router` â tree structure, compression and lookup documented in
  [ROUTER_v0.24](ROUTER_v0.24.md).
- Notes in [NOTES_FROM_SOURCE_v0.24.md](NOTES_FROM_SOURCE_v0.24.md) cover router defaults.
  Dir fang and typed headers are also summarized.

- `ohkami/src/format` explained in [FORMAT_v0.24](FORMAT_v0.24.md)
  with a custom CSV example.
 - `ohkami/src/header` described in [HEADERS_v0.24](HEADERS_v0.24.md)
   including typed header wrappers, parsing helpers, cookie iteration and
   precompressed file detection.
- `ohkami/src/ws` covered in [WS_v0.24](WS_v0.24.md)
  with `upgrade_durable`, `SessionMap` and split connections.

- `ohkami/src/session` - lifecycle explained in [SESSION_v0.24](SESSION_v0.24.md)
including connection trait details.
- Cloud runtime adapters (`x_worker`, `x_lambda`) documented in
  [RUNTIME_ADAPTERS_v0.24](RUNTIME_ADAPTERS_v0.24.md) now include
  examples for `#[bindings]` (with env selection) and Lambda WebSocket handling.
- `util` helpers and the `ohkami_lib` crate covered in [UTILS_v0.24](UTILS_v0.24.md).
- Error conversions via `IntoResponse` documented in
  [ERROR_HANDLING_v0.24](ERROR_HANDLING_v0.24.md).
- Procedural macros in [MACROS_v0.24](MACROS_v0.24.md) now include examples for
  `#[operation]`, `#[worker]` and `#[bindings(env)]`.
- `ohkami_openapi` documented in [OPENAPI_v0.24](OPENAPI_v0.24.md) with examples
  for `openapi::Tag` and custom `#[openapi::operation]` overrides.
- Dependency injection, typed error handling and custom path parameter parsing now covered in
  [PATTERNS_v0.24](PATTERNS_v0.24.md).
- Example projects in `samples/` summarized in [SAMPLES_v0.24](SAMPLES_v0.24.md).
- The [examples/README](examples/README.md) now lists every example with a short description.
- Quick start server documented in [examples/quick_start.md](examples/quick_start.md).
- JSON serialization illustrated in [examples/json_response.md](examples/json_response.md).
- Token based auth shown in [examples/jwt.md](examples/jwt.md)
- HTTP Basic auth covered in [examples/basic_auth.md](examples/basic_auth.md)
- Custom extraction traits in [examples/derive_from_request.md](examples/derive_from_request.md)
- File uploads demonstrated in [examples/form.md](examples/form.md)
- Hello world app in [examples/hello.md](examples/hello.md) showing custom
  fangs and typed status
- Server‑sent events showcased in [examples/sse.md](examples/sse.md).
- ChatGPT relay example in [examples/chatgpt.md](examples/chatgpt.md) shows
  `DataStream` with an external API.
- Static file options covered in
  [examples/static_files.md](examples/static_files.md).
- HTML layout with UIbeam shown in [examples/html_layout.md](examples/html_layout.md).
- WebSocket echo patterns described in
  [examples/websocket.md](examples/websocket.md).
- Multiple single-threaded runtimes shown in
  [examples/multiple-single-threads.md](examples/multiple-single-threads.md).
- `Taskfile.yaml` tasks explained in [TASKS_v0.24](TASKS_v0.24.md) including check, test and bench.
- Benchmark crates explained in [BENCHES_v0.24](BENCHES_v0.24.md) with lists
  of micro modules (including response header and `TupleMap` benchmarks) and
  runtime comparison crates.
- Cargo feature flags detailed in
  [FEATURE_FLAGS_v0.24](FEATURE_FLAGS_v0.24.md) including runtime specific notes.
- Workspace setup documented in [../ENV_SETUP.md](../ENV_SETUP.md).

## Partially Documented
Router internals are now covered in more detail with notes on automatic
`OPTIONS` handlers, merging nested `Ohkami`s and native runtime compression.
The WebSocket guide shows `upgrade_durable` and the `SessionMap` helper for
Workers. The `sse` module covers `DataStream::new`, queue‑based streaming and
custom `Data` implementations. Further real‑world guides for the `Dir` fang
would be valuable.

Additional gaps:

- Benchmarking basics are documented but real performance numbers are still
  missing.
- More real-world taskfile usage examples would help new contributors.
- Utility modules `ohkami_lib::stream`, `slice`, `time` and `num` are now covered
  in [UTILS_v0.24](UTILS_v0.24.md) with a queue streaming example.
- The AWS Lambda WebSocket adapter is partially implemented and now documented
  in [RUNTIME_ADAPTERS_v0.24](RUNTIME_ADAPTERS_v0.24.md), though the request and
  response mapping layer is still a work in progress.
- Outstanding ideas and missing features are summarized in
  [FEATURE_REQUESTS.md](FEATURE_REQUESTS.md).
- Each guide should be audited for accuracy. See
  [DOCS_TODO_v0.24.md](DOCS_TODO_v0.24.md) for the full checklist.

Contributions are welcome! Add notes or examples for any missing areas so both
humans and LLMs can understand the framework more completely.
