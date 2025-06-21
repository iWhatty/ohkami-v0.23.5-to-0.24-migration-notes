# Documentation Roadmap

This roadmap tracks coverage of the Ohkami **v0.24** source code in the Markdown guides.
It highlights which modules are documented and notes areas that still need work.

## Well Covered

- `ohkami/src/ohkami` – explained throughout [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md).
- `ohkami/src/fang` – builtin middleware covered in [FANGS_v0.24](FANGS_v0.24.md), [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md) and [PATTERNS_v0.24](PATTERNS_v0.24.md).
- `ohkami/src/testing` – usage described in both guides above.
- `ohkami/src/tls` – setup instructions in [STARTUP_GUIDE_v0.24](STARTUP_GUIDE_v0.24.md).
- `ohkami/src/request` and `ohkami/src/response` – detailed in [REQUEST_v0.24](REQUEST_v0.24.md) and [RESPONSE_v0.24](RESPONSE_v0.24.md).
- `ohkami/src/typed` – explained in [TYPED_v0.24](TYPED_v0.24.md).
- `ohkami/src/lib.rs` – crate root documented in the main README.
- `ohkami/src/lib.rs::prelude` – imports covered in [PRELUDE_v0.24](PRELUDE_v0.24.md).
- `ohkami/src/ohkami/dir` – static file serving in [DIR_v0.24](DIR_v0.24.md).
- `ohkami/src/config` – environment variables documented in
  [CONFIGURATION_v0.24](CONFIGURATION_v0.24.md).
- `ohkami/src/router` – tree structure and lookup process described in
  [ROUTER_v0.24](ROUTER_v0.24.md).

- `ohkami/src/session` – lifecycle explained in [SESSION_v0.24](SESSION_v0.24.md).
- Cloud runtime adapters (`x_worker`, `x_lambda`) documented in [RUNTIME_ADAPTERS_v0.24](RUNTIME_ADAPTERS_v0.24.md).
- `util` helpers and the `ohkami_lib` crate covered in [UTILS_v0.24](UTILS_v0.24.md).
- Procedural macros in [MACROS_v0.24](MACROS_v0.24.md).
- `ohkami_openapi` documented in [OPENAPI_v0.24](OPENAPI_v0.24.md).
- Dependency injection and typed error patterns now covered in
  [PATTERNS_v0.24](PATTERNS_v0.24.md).
- Example projects under `samples/` summarized in [SAMPLES_v0.24](SAMPLES_v0.24.md).
- `Taskfile.yaml` commands described in [TASKS_v0.24](TASKS_v0.24.md).
- Benchmark crates explained in [BENCHES_v0.24](BENCHES_v0.24.md).
- Cargo feature flags listed in [FEATURE_FLAGS_v0.24](FEATURE_FLAGS_v0.24.md).

## Partially Documented

- `format`, `header`, `ws`, `sse` and portions of the router internals now include example code in their docs. Further real-world guides are still welcome. `Dir` was recently documented but additional recipes are encouraged.

Additional gaps:

- Benchmarking basics are documented but real performance numbers are still
  missing.
- More real‑world taskfile usage examples would help new contributors.
- Utility modules such as `ohkami_lib::stream`, `slice`, `time` and `num` are not
  yet covered in [UTILS_v0.24](UTILS_v0.24.md).
- The AWS Lambda WebSocket adapter remains unfinished and lacks documentation.

Contributions are welcome!  Add notes or examples for any missing areas so both humans and LLMs can understand the framework more completely.
