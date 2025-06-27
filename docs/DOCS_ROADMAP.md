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
- `ohkami/src/lib.rs::prelude` — exports documented in [PRELUDE_v0.24](PRELUDE_v0.24.md)
  with notes on runtime gating.
- `ohkami/src/ohkami/dir` — static file serving in [DIR_v0.24](DIR_v0.24.md),
 including notes on preloading, compression and cache headers.
- `ohkami/src/config` â environment variables documented in
  [CONFIGURATION_v0.24](CONFIGURATION_v0.24.md). Values are loaded once at
  startup through the [`CONFIG`](../ohkami-0.24/ohkami/src/config.rs) static.
- `ohkami/src/router` â tree structure, compression and lookup documented in
  [ROUTER_v0.24](ROUTER_v0.24.md).

- `ohkami/src/session` - lifecycle explained in [SESSION_v0.24](SESSION_v0.24.md)
including connection trait details.
- Cloud runtime adapters (`x_worker`, `x_lambda`) documented in
  [RUNTIME_ADAPTERS_v0.24](RUNTIME_ADAPTERS_v0.24.md) now include
  examples for `#[bindings]` and Lambda WebSocket handling.
- `util` helpers and the `ohkami_lib` crate covered in [UTILS_v0.24](UTILS_v0.24.md).
- Error conversions via `IntoResponse` documented in
  [ERROR_HANDLING_v0.24](ERROR_HANDLING_v0.24.md).
- Procedural macros in [MACROS_v0.24](MACROS_v0.24.md) now include examples for
  `#[operation]`, `#[worker]` and `#[bindings]`.
- `ohkami_openapi` documented in [OPENAPI_v0.24](OPENAPI_v0.24.md) with examples
  for `openapi::Tag` and custom `#[openapi::operation]` overrides.
- Dependency injection and typed error patterns now covered in
  [PATTERNS_v0.24](PATTERNS_v0.24.md).
- Example projects in `samples/` summarized in [SAMPLES_v0.24](SAMPLES_v0.24.md).
- Quick start server documented in [examples/quick_start.md](examples/quick_start.md).
- JSON serialization illustrated in [examples/json_response.md](examples/json_response.md).
- Server‑sent events showcased in [examples/sse.md](examples/sse.md).
- Static file options covered in
  [examples/static_files.md](examples/static_files.md).
- `Taskfile.yaml` tasks explained in [TASKS_v0.24](TASKS_v0.24.md) including check, test and bench.
- Benchmark crates explained in [BENCHES_v0.24](BENCHES_v0.24.md), including lists
  of micro benchmark modules and runtime comparison crates.
- Cargo feature flags detailed in
  [FEATURE_FLAGS_v0.24](FEATURE_FLAGS_v0.24.md) including runtime specific notes.
- Workspace setup documented in [../ENV_SETUP.md](../ENV_SETUP.md).

## Partially Documented
- `format` (including the `bound` traits and a CSV example),
  `header`, and `ws` plus portions of the router internals now
include example code in their docs. The WebSocket guide covers
`upgrade_durable` and the `SessionMap` helper for Workers. `sse` recently
gained a section on `DataStream::from` and custom `Data` implementations.
The header guide covers `AcceptEncoding` parsing and `Set-Cookie`
iteration. Further real‑world guides are still welcome. `Dir` was recently
documented but additional recipes are encouraged.

Additional gaps:

- Benchmarking basics are documented but real performance numbers are still
  missing.
- More realâworld taskfile usage examples would help new contributors.
- Utility modules `ohkami_lib::stream`, `slice`, `time` and `num` are now covered
  in [UTILS_v0.24](UTILS_v0.24.md).
- The AWS Lambda WebSocket adapter remains unfinished and lacks documentation.
- Each guide should be audited for accuracy. See
  [DOCS_TODO_v0.24.md](DOCS_TODO_v0.24.md) for the full checklist.

Contributions are welcome! Add notes or examples for any missing areas so both
humans and LLMs can understand the framework more completely.
