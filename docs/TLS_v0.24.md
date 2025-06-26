# TLS Support

The `tls` feature enables HTTPS servers using [rustls](https://github.com/rustls).
It requires the `rt_tokio` runtime and wraps each TCP connection in
[`TlsStream`](../ohkami-0.24/ohkami/src/tls/mod.rs). `TlsStream` implements the
`Connection` trait consumed by `Session`.

Run a server over TLS by calling `howls` instead of `howl` and passing a
`rustls::ServerConfig`:

```rust,no_run
use ohkami::prelude::*;
use rustls::ServerConfig;

#[tokio::main]
async fn main() {
    let tls_config = ServerConfig::builder()
        .with_no_client_auth()
        .with_single_cert(load_certs(), load_key())
        .expect("TLS config");

    Ohkami::new( (
        "/".GET(|| async {"secure"})
    )).howls("0.0.0.0:8443", tls_config).await;
}
```

`howls` performs the TLS handshake using `tokio_rustls::TlsAcceptor` and serves
HTTP/1.1 responses. WebSocket upgrades are not supported over TLS yet.

For a complete certificate loading example see the
[README](../ohkami-0.24/README.md#tls).
