# WebSocket Echo Examples

Several echo servers showcasing different ways to use WebSockets in Ohkami.
`/echo1` upgrades directly, `/echo2` wraps the upgrade in a custom type and
`/echo3` demonstrates splitting the connection.  Static HTML templates are served
from `template/` for testing with a browser.

## Files

- `src/main.rs` – contains four echo handlers and mounts the routes.
- `template/index.html` – simple browser client for manual testing.

### `src/main.rs`

Each handler shows a different upgrade pattern:

- `echo_text` – direct upgrade, sending back each received text frame.
- `echo_text_2` – returns a type implementing `IntoResponse` for deferred upgrade.
- `echo_text_3` – splits the socket and spawns tasks to manage read/write.
- `echo4` – demonstrates spawning without awaiting the join handle.

```bash
$ cargo run --example websocket
```
