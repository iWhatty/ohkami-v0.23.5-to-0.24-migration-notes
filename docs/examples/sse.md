# Server‑Sent Events Example

Streams a sequence of messages to the client using Ohkami's built‑in SSE
support.  Each second another event is sent until the stream completes.

```bash
$ cargo run --example sse
```

Navigate to `http://localhost:3020/sse` in your browser or `curl` the same URL to
watch the events.
