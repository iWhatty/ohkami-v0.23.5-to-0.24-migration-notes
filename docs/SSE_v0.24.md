# Server‑Sent Events

The `sse` feature provides the [`DataStream`](../ohkami-0.24/ohkami/src/sse)
response type for sending event streams over HTTP. Each item must implement the
`Data` trait which converts it to a string. `DataStream` implements
`IntoResponse` so calling handlers can simply return it and the
`content-type: text/event-stream` header is added automatically.

```rust
async fn handler() -> DataStream {
    DataStream::new(|mut s| async move {
        s.send("start");
        // push events asynchronously
    })
}
```

`DataStream::new` passes a [`handle::Stream`](../ohkami-0.24/ohkami/src/sse/mod.rs#L121)
to the provided closure. Calling `send` on this handle queues an encoded value
to be streamed to the client. The queue runs until the async block completes,
yielding events in the order they are pushed.

`DataStream` wraps any `Stream<Item = T>` where `T: Data`.  Calling
`DataStream::new` spawns an async producer with a queue.  The response is sent
with `content-type: text/event-stream`.
Instead of spawning a new queue you may wrap any existing
`Stream<Item = T>` with `DataStream::from`:

```rust
use tokio_stream::{wrappers::IntervalStream, StreamExt};
use tokio::time::{interval, Duration};

async fn ticks() -> DataStream {
    let s = IntervalStream::new(interval(Duration::from_secs(1)))
        .map(|_| "tick");
    DataStream::from(s)
}
```

On the consumer side browsers can read these events using the JavaScript
`EventSource` API.  Remember that Ohkami currently streams using HTTP/1.1
chunked encoding, so a reverse proxy is required if you need HTTP/2 or HTTP/3
support.

Implement the `Data` trait for custom event types to control how items are
encoded before being sent. When the `openapi` feature is active the
implementation also contributes schema information to the generated
document, allowing clients to infer the event payload type:

```rust
use ohkami::sse::Data;

#[derive(openapi::Schema)]
struct Event { msg: String }

impl Data for Event {
    fn encode(self) -> String {
        serde_json::to_string(&self).unwrap()
    }
}
```




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

## Implementation Notes

`DataStream` wraps a boxed `Stream<Item = String>` and a marker for the original
data type. Its definition appears around lines 38‑41 of
[`sse/mod.rs`](../ohkami-0.24/ohkami/src/sse/mod.rs#L38-L41). When converted into
a response, `into_response` sets this stream on `Response::OK` without any
additional boxing. See lines 66‑72 for the details.

`DataStream::new` creates an internal queue using
`QueueStream::new` and hands a [`handle::Stream`](../ohkami-0.24/ohkami/src/sse/mod.rs#L126-L143)
to your closure. Each call to `send` pushes an encoded item onto this queue,
which is then pulled by the streaming response. The closure runs to completion
while the client receives each item in order.
