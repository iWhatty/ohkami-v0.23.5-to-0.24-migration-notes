# ChatGPT Relay Example

Demonstrates using Ohkami to forward client questions to the OpenAI ChatGPT
API.  It streams responses back to the browser using Server‑Sent Events.

Set an OpenAI API key via the `OPENAI_API_KEY` environment variable or pass
`-- --api-key <KEY>` when running.

```bash
$ cargo run --example chatgpt -- --api-key <YOUR_KEY>
```

POST a message to `/chat-once` and receive streamed chunks in real time.
