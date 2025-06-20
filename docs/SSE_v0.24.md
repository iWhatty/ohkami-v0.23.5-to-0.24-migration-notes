# Server‑Sent Events

The `sse` feature provides the [`DataStream`](../ohkami-0.24/ohkami/src/sse)
response type for sending event streams over HTTP.  Each item must implement the
`Data` trait which converts it to a string.

```rust
async fn handler() -> DataStream {
    DataStream::new(|mut s| async move {
        s.send("start");
        // push events asynchronously
    })
}
```

`DataStream` wraps any `Stream<Item = T>` where `T: Data`.  Calling
`DataStream::new` spawns an async producer with a queue.  The response is sent
with `content-type: text/event-stream`.

On the consumer side browsers can read these events using the JavaScript
`EventSource` API.  Remember that Ohkami currently streams using HTTP/1.1
chunked encoding, so a reverse proxy is required if you need HTTP/2 or HTTP/3
support.

Implement the `Data` trait for custom event types to control how items are
encoded before being sent.  When the `openapi` feature is active the
implementation also contributes schema information to the generated document.




Example server using `tokio` runtime:

```rust,no_run
use ohkami::prelude::*;
use ohkami::sse::DataStream;
use tokio::time::{sleep, Duration};

async fn stream() -> DataStream {
    DataStream::new(|mut s| async move {
        for i in 1..=3 {
            sleep(Duration::from_secs(1)).await;
            s.send(format!("tick {i}"));
        }
    })
}

#[tokio::main]
async fn main() {
    Ohkami::new(("/events".GET(stream))).howl("localhost:3030").await;
}
```
