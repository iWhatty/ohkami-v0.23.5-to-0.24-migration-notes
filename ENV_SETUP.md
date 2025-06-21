# Environment Setup Guide

Follow these steps to build and run the Ohkami sources included in this repository.

## Prerequisites

- Install Rust via [rustup](https://rustup.rs) and make sure `cargo` is on your PATH.
- Use a toolchain that supports the 2024 edition. A recent stable release is fine.
- The optional [`task`](https://taskfile.dev) CLI provides shortcuts for common commands.

## Initial build

Run the build once so Cargo downloads all crates:

```bash
cd ohkami-0.24
cargo build
```

This compiles every workspace crate and caches dependencies in `~/.cargo/`.

## Development tasks

Inside `ohkami-0.24` you can run:

```bash
# check all crates
cargo check

# run tests
cargo test
```

If you installed `task`, the shortcut `task ci` formats, checks and tests the code.

## Runtime configuration

Three environment variables tweak server behavior when using native runtimes:

- `OHKAMI_REQUEST_BUFSIZE` – request buffer size in bytes (default 2048).
- `OHKAMI_KEEPALIVE_TIMEOUT` – keep‑alive timeout in seconds (default 30).
- `OHKAMI_WEBSOCKET_TIMEOUT` – WebSocket timeout in seconds (default 3600).

Increase these values if clients send large headers or hold WebSocket connections open.
