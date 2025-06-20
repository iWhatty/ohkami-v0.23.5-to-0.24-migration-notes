# ChatGPT Relay Example

Demonstrates using Ohkami to forward client questions to the OpenAI ChatGPT
API.  It streams responses back to the browser using Server‑Sent Events.

Set an OpenAI API key via the `OPENAI_API_KEY` environment variable or pass
`-- --api-key <KEY>` when running.

```bash
$ cargo run --example chatgpt -- --api-key <YOUR_KEY>
```

POST a message to `/chat-once` and receive streamed chunks in real time.

## Files

- `src/main.rs` – contains the relay logic and defines the `/chat-once` route.
- `src/fangs.rs` – loads the API key from the environment and inserts it into the
  request context.
- `src/models.rs` and `src/error.rs` – typed API payloads and error handling.

### Flow

1. `APIKey` fang attaches the OpenAI key to each request.
2. `relay_chat_completion` forwards the request to the OpenAI endpoint and
   returns a streaming `DataStream` of the response chunks.
