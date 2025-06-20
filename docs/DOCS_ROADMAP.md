# Documentation Roadmap

This roadmap tracks coverage of the Ohkami **v0.24** source code in the Markdown guides.
It highlights which modules are documented and notes areas that still need work.

## Well Covered

- `ohkami/src/ohkami` – explained throughout [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md).
- `ohkami/src/fang` – builtin middleware referenced in [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md) and [PATTERNS_v0.24](PATTERNS_v0.24.md).
- `ohkami/src/testing` – usage described in both guides above.
- `ohkami/src/tls` – setup instructions in [STARTUP_GUIDE_v0.24](STARTUP_GUIDE_v0.24.md).

- `ohkami/src/session` – lifecycle explained in [SESSION_v0.24](SESSION_v0.24.md).
- Cloud runtime adapters (`x_worker`, `x_lambda`) documented in [RUNTIME_ADAPTERS_v0.24](RUNTIME_ADAPTERS_v0.24.md).
- `util` helpers and the `ohkami_lib` crate covered in [UTILS_v0.24](UTILS_v0.24.md).
- Procedural macros in [MACROS_v0.24](MACROS_v0.24.md).

## Partially Documented

- `format`, `header`, `ws`, `sse` and the router internals now each have short
  descriptions in dedicated Markdown files.
- The `ohkami_openapi` crate is still undocumented.


Contributions are welcome!  Add notes or examples for any missing areas so both humans and LLMs can understand the framework more completely.
