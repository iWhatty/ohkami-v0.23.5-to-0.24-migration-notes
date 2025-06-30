# ChatGPT Relay Example

Demonstrates using Ohkami to forward client questions to the OpenAI ChatGPT API
and stream the assistant reply with Server‑Sent Events.  Set an API key via the
`OPENAI_API_KEY` variable or pass `-- --api-key <KEY>` when running.

```bash
$ cargo run --example chatgpt -- --api-key <YOUR_KEY>
```

POST a plain text message to `/chat-once` and you will receive chunks in real
time.  The example converts each line from OpenAI into an SSE `DataStream`.

## Files

- `src/main.rs` – contains the relay logic and defines the `/chat-once` route.
- `src/fangs.rs` – loads the API key from the environment and inserts it into the
  request context.
- `src/models.rs` and `src/error.rs` – typed API payloads and error handling.

### Flow

1. `APIKey` fang attaches the OpenAI key to each request.
2. `relay_chat_completion` forwards the prompt and converts the streaming
   response into a `DataStream`.

```rust
async fn relay_chat_completion(
    Context(APIKey(key)): Context<'_, APIKey>,
    Text(prompt): Text<String>,
) -> Result<DataStream, Error> { /* ... */ }
```

`DataStream::new` is used internally to push each decoded line to the client.
