# Benchmarks

The repository includes micro benchmarks under `ohkami-0.24/benches`. These use
Rust's built‑in `criterion` and nightly `test` harnesses to measure
performance of internal utilities like header parsing.

Run benchmarks from the workspace root with:

```sh
cargo bench --workspace
```

The `benches_rt` directory contains experiments comparing runtimes. Each
subfolder (`tokio`, `smol`, `nio`, `glommio`) is a small binary crate that can be
executed with `cargo run --release` to gauge throughput on your machine.
