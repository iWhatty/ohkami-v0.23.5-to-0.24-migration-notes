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


