# Utility Helpers

Several small helpers live under
[`ohkami/src/util.rs`](../ohkami-0.24/ohkami/src/util.rs) and the companion
[`ohkami_lib` crate](../ohkami-0.24/ohkami_lib).
They provide functionality used across the framework but are also handy in
applications. Recent additions cover more of `ohkami_lib` including numeric
helpers and a small async stream adapter.

## Logging Macros

- `INFO!`, `WARNING!`, `ERROR!` and `DEBUG!` print messages consistently whether
  running natively or in Cloudflare Workers. Each macro forwards to `eprintln!`
  or `worker::console_*` as appropriate.
- `push_unchecked!` quickly appends bytes onto a `Vec<u8>` without reallocating
  when the capacity is sufficient.

## Data Utilities

- Base64 helpers: `base64_encode`, `base64_decode`, `base64_decode_utf8` and
  URL‑safe `base64_url_encode`/`base64_url_decode`.
- `iter_cookies` parses a raw `Cookie` header into `(name, value)` pairs.
- Example:
```rust
let mut it = ohkami::util::iter_cookies(
    "PHPSESSID=298zf09hf012fh2; csrftoken=u32t4o3tb3gg43"
);
assert_eq!(it.next(), Some(("PHPSESSID", "298zf09hf012fh2")));
assert_eq!(it.next(), Some(("csrftoken", "u32t4o3tb3gg43")));
assert_eq!(it.next(), None);
```
- `unix_timestamp` returns the current Unix time and works in both native and
  worker environments.
- `timeout_in` wraps a future with a timeout when using native runtimes.
```rust,no_run
use std::time::Duration;

let result = ohkami::util::timeout_in(Duration::from_secs(1), async {
    slow_operation().await
}).await;
if let Some(v) = result {
    println!("finished: {v}");
} else {
    println!("timed out");
}
```
- `percent_encode`, `percent_decode` and `percent_decode_utf8` provide basic URL
  encoding helpers used throughout the framework.

Other helpers include:

- `ErrorMessage` — simple error type implementing `IntoResponse` for 500s.
- `imf_fixdate` formats timestamps for HTTP `Date` headers.
- `IP_0000` constant representing `0.0.0.0` for binding servers.

## ohkami_lib Crate

The `ohkami_lib` crate re-exports small utilities used by the framework:

- `TupleMap` – a small vector-backed map for a handful of key/value pairs.
- Percent‑encoding helpers: `percent_encode`, `percent_decode`, and `percent_decode_utf8`.
- Modules under `serde_*` implement custom (de)serialization for cookies and
  forms plus URL encoding helpers.

These helpers keep Ohkami lightweight while avoiding extra dependencies in user code.

### Additional Modules

- `stream` – async helpers like `queue` and `StreamExt` used by SSE and examples.
- `slice` and `CowSlice` – manual byte slice types for zero-copy operations.
- `num` – `itoa` and `hexized` for efficient number formatting.
- `time` – `imf_fixdate` to produce RFC 9110 date strings.

### Stream Queue Example

The `stream` module includes a `queue` helper which spawns an async task pushing
items into a buffer. The resulting stream can be combined with SSE or other
code using `StreamExt` methods.

```rust,no_run
use ohkami::sse::DataStream;
use ohkami::util::{stream, StreamExt};
use tokio::time::{sleep, Duration};

async fn events() -> DataStream {
    DataStream::from(stream::queue(|mut q| async move {
        for i in 0..3 {
            sleep(Duration::from_secs(1)).await;
            q.push(format!("tick {i}"));
        }
    }))
}
```

See [`ohkami_lib/src/stream.rs`](../ohkami-0.24/ohkami_lib/src/stream.rs) for
implementation details.
