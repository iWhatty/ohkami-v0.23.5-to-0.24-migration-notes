# Server‑Sent Events Example

Demonstrates streaming messages to the client with Ohkami's built‑in
Server‑Sent Events support. The handler sends five events with a one second
delay between them.

## Files

- `Cargo.toml` – declares the `ohkami` and `tokio` dependencies.
- `src/main.rs` – defines a single `/sse` route that returns `DataStream`.

### `src/main.rs`

`handler` creates the streaming response and `main` mounts it under `/sse`.

```rust
use ohkami::prelude::*;
use ohkami::sse::DataStream;
use tokio::time::{sleep, Duration};

async fn handler() -> DataStream {
    DataStream::new(|mut s| async move {
        s.send("starting streaming...");
        for i in 1..=5 {
            sleep(Duration::from_secs(1)).await;
            s.send(format!("MESSAGE #{i}"));
        }
        s.send("streaming finished!");
    })
}

#[tokio::main]
async fn main() {
    Ohkami::new(("/sse".GET(handler))).howl("localhost:3020").await
}
```

See [`src/main.rs`](../../ohkami-0.24/examples/sse/src/main.rs) for the full file.

```bash
$ cargo run --example sse
```

Navigate to `http://localhost:3020/sse` in your browser or `curl` the same URL to
watch the events.
