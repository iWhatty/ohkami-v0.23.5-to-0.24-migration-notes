# Ohkami 0.23.5 -> 0.24 Migration Notes

This repository contains notes on the main changes between versions **0.23.5** and **0.24** of the [Ohkami](https://github.com/ohkami-rs/ohkami) web framework.  All code from both versions is included under `ohkami-0.23.5/` and `ohkami-0.24/` for reference.

## Workspace adjustments

- The workspace now uses `resolver = "3"` and Rust edition `2024`.
  ```toml
  # 0.23.5 Cargo.toml
  resolver = "2"
  edition  = "2021"
  # 0.24 Cargo.toml
  resolver = "3"
  edition  = "2024"
  ```

## Crate changes

### Runtime features
- The `rt_async-std` feature was removed. Supported native runtimes are now `tokio`, `smol`, `nio` and `glommio`.
- New `tls` feature adds HTTPS support via `rustls` and `tokio-rustls`.

### Macros crate
- Worker support depends on additional crates: `jsonc-parser` and `serde`.

### Configuration
- Environment variable `OHKAMI_REQUEST_BUFSIZE` controls request buffer size.

## API updates

- `Ohkami::howls()` starts a TLS server using a `rustls::ServerConfig`.
- A `tls` module introduces `TlsStream` implementing `Connection` for TLS sessions.
- `Dir` handling was rewritten with support for precompressed files, ETag generation and `Accept-Encoding` negotiation.
- `Session` is generic over a `Connection` trait, allowing TLS streams.
- Improved route segment validation accepts `[a-zA-Z0-9-._~]`.

## Documentation changes

- README expanded with examples for TLS and additional worker details.
- Async‑std references were removed from the feature list.
- Workers section describes the new `bindings` macro and durable object helpers.

Refer to the source of each version for full details.  See the `ohkami-0.23.5` and `ohkami-0.24` directories for the exact code.

For a hands-on introduction to Ohkami **v0.24**, check out the [start-up guide](docs/STARTUP_GUIDE_v0.24.md) with examples and TLS setup.

For walkthroughs of the sample applications, see the guides in
[docs/examples](docs/examples/README.md).
