# Server‑Sent Events Example

Streams a sequence of messages to the client using Ohkami's built‑in SSE
support.  Each second another event is sent until the stream completes.

## Files

- `src/main.rs` – defines a single `/sse` route that returns `DataStream`.

### `src/main.rs`

`handler` creates a streaming response that emits five messages with a one
second delay between them. The `main` function mounts this handler and listens
on `localhost:3020`.

```bash
$ cargo run --example sse
```

Navigate to `http://localhost:3020/sse` in your browser or `curl` the same URL to
watch the events.
