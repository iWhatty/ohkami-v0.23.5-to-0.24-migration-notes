# Taskfile Commands

Development chores are automated via `Taskfile.yaml` at the workspace root.
The [YAML](../ohkami-0.24/Taskfile.yaml) is executed by the
[`task` CLI](https://taskfile.dev). Install the binary first, then run commands
such as `task check` or `task ci` from the repository root.

## Layout Overview

`Taskfile.yaml` defines a small dependency graph of commands so contributors can
reproduce the continuous integration flow locally.

- `task CI` calls the `test`, `check` and `bench:dryrun` tasks, matching the
  pipeline executed on GitHub Actions (`Taskfile.yaml`, lines 6‑15).
- `task test` fans out into `test:core` and `test:other`, letting you run
  runtime specific tests separately from documentation and examples
  (lines 16‑33).
- `task check` mirrors the runtime matrix but uses `cargo check` instead of the
  slower test suite and also triggers the WASM build for Workers
  (lines 35‑60, 102‑143).

### Runtime Matrix

The `test:core` and `check` tasks iterate over a list of runtimes declared
inline: `tokio`, `smol`, `nio`, `glommio`, `lambda` and `worker`
(lines 20‑23, 40‑43). Each runtime triggers `cargo test` or `cargo check` with
four feature sets:

1. Base runtime (`rt_*`).
2. Runtime plus `sse`.
3. Runtime plus `ws`.
4. Runtime plus `sse`, `ws` and `openapi` for full integration coverage.

On native runtimes the commands run against the host target, while the Workers
variant compiles for `wasm32-unknown-unknown`. You can scope a single runtime by
passing `--rt`:

```sh
task test:rt --rt tokio
task check:rt-native_target --rt glommio
```

`test:tls` and `check:tls` run extra combinations guarded by the Tokio runtime
because TLS currently depends on `tokio-rustls` (lines 74‑83, 118‑125).

### Conditional Nightly Features

The top-level `maybe_nightly` variable inspects `cargo version` and, when a
nightly toolchain is detected, appends the `nightly` feature to every command
(`Taskfile.yaml`, lines 3‑5). This avoids build failures when contributors run
stable rustc while still enabling nightly-only optimisations in CI.

### Tests Beyond Core Runtimes

`test:other` groups tasks that do not depend on a specific runtime (lines 24‑33):

- `test:deps` runs crate-level unit tests for `ohkami_lib` and `ohkami_openapi`.
- `test:doc` executes documentation tests for the `ohkami` crate with a broad
  feature set minus `openapi` to keep README samples reproducible.
- `test:examples` and `test:samples` call the helper scripts inside those
  directories, ensuring the shell-based example checks stay in sync.

Running `task test` therefore covers runtimes, library crates, doc tests and all
published examples in one go.

### Check Tasks

`check:no_rt` verifies that the core library builds without any runtime features
before layering in `sse`, `ws` and `openapi` combinations (lines 102‑111).
`check:rt-native_target` repeats the runtime loop for native targets, while
`check:rt_worker` performs the same feature matrix for the WASM target used by
Cloudflare Workers (lines 112‑143).

### Benchmarks

Benchmarks are split into two tasks. `bench:dryrun` builds the binaries without
running them so contributors can confirm everything compiles on stable Rust
(lines 45‑53). `bench` depends on `bench:dryrun` and then executes the benches,
but both tasks short-circuit when `cargo version` reports a nightly toolchain to
avoid duplicate work in CI (lines 45‑70).

### Practical Tips

- Use `task CI` before pushing a change to mirror the automated pipeline.
- When iterating on a single runtime pass `--rt` to `test:rt` or
  `check:rt-native_target` to save time.
- The example and sample tests rely on executable shell scripts; if permissions
  drift, the tasks will reapply `chmod +x` automatically (lines 64‑73).

These tasks are optional for end users but provide a consistent developer
experience that mirrors the repository's CI jobs.
