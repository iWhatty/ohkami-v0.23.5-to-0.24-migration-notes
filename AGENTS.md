# Doc Contribution Guide

This repository focuses on documentation for Ohkami v0.24.

* Place all Markdown guides under the `docs/` directory. Use the suffix `_v0.24` for
  files that specifically cover the 0.24 code.
* Keep lines under 100 characters for readability.
* Link to source files using relative paths to the `ohkami-0.24` directory.
* Whenever a new doc is added or changed, update `docs/README.md` so readers can find it.
* Update `docs/DOCS_ROADMAP.md` with notes about which modules are documented and any remaining gaps.
* Code changes should compile via `cargo check` under `ohkami-0.24` when applicable, but
  documentation-only changes do not require compilation.
