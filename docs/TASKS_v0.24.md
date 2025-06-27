# Taskfile Commands

Development chores are automated via `Taskfile.yaml` at the workspace root. The
[YAML](../ohkami-0.24/Taskfile.yaml) defines commands run by the `task` CLI
(https://taskfile.dev).

Common tasks include:

- `task check` – run `cargo check` for all crates.
- `task test` – execute the test suite.
- `task fmt` – format the code using `cargo fmt`.
- `task ci` – shortcut that runs formatting, checks and tests; used by CI.

Install the `task` binary from <https://taskfile.dev> then run e.g.:

```sh
# format and check code
task ci
```

These tasks are optional but mirror the commands used in CI pipelines.

Additional helpers:

- `task bench:dryrun` – build all benchmarks without executing them.
- `task bench` – run micro benchmarks in the `benches` crate.
- `task test:rt --rt tokio` – run tests for a single runtime (tokio, smol, etc.).
- `task check:rt-native_target --rt tokio` – build for a specific runtime without running.

The main `task test` and `task check` commands call these subtasks to cover all
supported runtimes and feature combinations.
