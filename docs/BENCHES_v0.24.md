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

### Bench Files

Micro benchmarks under `benches/benches` cover:

- `content.rs` — copy strategies for request bodies.
- `imf_fixdate.rs` — formatting RFC 1123 dates.
- `itoa.rs` — integer to ASCII conversions.
- `request_headers.rs` — parsing incoming headers.

Common helpers live in `benches/src`, such as the `header_map.rs` example map.

Runtime benchmarks live in `benches_rt`:

- `tokio`, `smol`, `nio` and `glommio` — minimal servers for each runtime.
- `vs_actix-web` — reference implementation using Actix Web.

## Adjusting Criterion

You can tweak the benchmark parameters by passing options after `--`.
For example to increase the sample size and warm up longer:

```sh
cargo bench --bench headers -- --sample-size 100 --warm-up-time 2
```

Results are written to `target/criterion`. Open the HTML report in that
directory to compare runs over time.

### Runtime Examples

The runtime comparison crates accept feature flags so you can test HTTPS or
other integrations. To benchmark the Tokio version with TLS enabled:

```sh
cd ohkami-0.24/benches_rt/tokio
cargo run --release --features tls
```
