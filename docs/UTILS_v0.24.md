# Utility Helpers

Several small helpers live under [`ohkami/src/util.rs`](../ohkami-0.24/ohkami/src/util.rs) and the companion [`ohkami_lib` crate](../ohkami-0.24/ohkami_lib). They provide functionality used across the framework but are also handy in applications.

## Logging Macros

- `INFO!`, `WARNING!`, `ERROR!` and `DEBUG!` print messages consistently whether
  running natively or in Cloudflare Workers. Each macro forwards to `eprintln!`
  or `worker::console_*` as appropriate.
- `push_unchecked!` quickly appends bytes onto a `Vec<u8>` without reallocating
  when the capacity is sufficient.

## Data Utilities

- Base64 helpers: `base64_encode`, `base64_decode`, and URL‑safe variants.
- `iter_cookies` parses a raw `Cookie` header into `(name, value)` pairs.
- `unix_timestamp` returns the current Unix time and works in both native and worker environments.
- `timeout_in` wraps a future with a timeout when using native runtimes.
- `percent_encode`, `percent_decode` and `percent_decode_utf8` provide basic URL
  encoding helpers used throughout the framework.

## ohkami_lib Crate

The `ohkami_lib` crate re-exports small utilities used by the framework:

- `TupleMap` – a small vector-backed map for a handful of key/value pairs.
- Percent‑encoding helpers: `percent_encode`, `percent_decode`, and `percent_decode_utf8`.
- Modules under `serde_*` implement custom (de)serialization for cookies, multipart forms, URL encoding and more.

These helpers keep Ohkami lightweight while avoiding extra dependencies in user code.
