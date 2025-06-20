# Documentation Roadmap

This roadmap tracks coverage of the Ohkami **v0.24** source code in the Markdown guides.
It highlights which modules are documented and notes areas that still need work.

## Well Covered

- `ohkami/src/ohkami` – explained throughout [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md).
- `ohkami/src/fang` – builtin middleware referenced in [CODING_GUIDE_v0.24](CODING_GUIDE_v0.24.md) and [PATTERNS_v0.24](PATTERNS_v0.24.md).
- `ohkami/src/testing` – usage described in both guides above.
- `ohkami/src/tls` – setup instructions in [STARTUP_GUIDE_v0.24](STARTUP_GUIDE_v0.24.md).

## Partially Documented

- `format` and `header` modules appear in code snippets but lack detailed explanations.
- `ws` and `sse` features are only touched on in examples.
- `router` internals are mentioned briefly but not fully described.

## Not Yet Covered

- `session` handling APIs.
- Cloud runtime adapters (`x_worker`, `x_lambda`).
- Utility helpers under `util` and the `ohkami_lib` crate.
- Procedural macros implemented in the `ohkami_macros` crate.

Contributions are welcome!  Add notes or examples for any missing areas so both humans and LLMs can understand the framework more completely.
