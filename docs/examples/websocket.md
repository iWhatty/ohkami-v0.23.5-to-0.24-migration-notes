# WebSocket Echo Examples

Several echo servers showcasing different ways to use WebSockets in Ohkami.
`/echo1` upgrades directly, `/echo2` wraps the upgrade in a custom type and
`/echo3` demonstrates splitting the connection.  Static HTML templates are served
from `template/` for testing with a browser.

```bash
$ cargo run --example websocket
```
