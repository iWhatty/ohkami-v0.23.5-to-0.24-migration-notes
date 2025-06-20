# TLS Support

Feature `tls` enables HTTPS servers using [rustls](https://github.com/rustls). The implementation wraps a TCP stream in [`TlsStream`](../ohkami-0.24/ohkami/src/tls/mod.rs) which implements the `Connection` trait used by `Session`.

To run a server over TLS call `howls` instead of `howl` and provide a configured `ServerConfig`:

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

Currently TLS only works with the `rt_tokio` runtime and HTTP/1.1. See the README in `ohkami-0.24` for a complete example including certificate loading.
