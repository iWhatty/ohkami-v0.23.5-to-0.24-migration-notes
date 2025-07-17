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
- `response_headers.rs` — inserting and formatting outgoing headers.
- `tuplemap_vs_hashmap.rs` — comparing custom `TupleMap` lookups to `HashMap`.

Common helpers live in `benches/src`.  Modules implement
`FxHashMap` wrappers and alternative header containers used by the
benchmark suites (see `header_map.rs` and `response_headers/`).

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

### Sample Results

A run of `cargo bench` on a Linux x86-64 machine with Rust 1.73 nightly
produced the following excerpts:

```text
test create_small_bytes ... bench:          33.80 ns/iter (+/- 2.53)
test create_small_cow   ... bench:           0.34 ns/iter (+/- 0.01)
test insert_ohkami      ... bench:          41.39 ns/iter (+/- 1.56)
test remove_ohkami      ... bench:          12.97 ns/iter (+/- 0.88)
```

These numbers show the low overhead of Ohkami's custom header map compared to
standard library structures.  See `bench-results.txt` in the repository for the
full output.
