# TLS Support

The `tls` feature enables HTTPS servers using
[rustls](https://github.com/rustls).  It requires the `rt_tokio` runtime and
wraps each TCP connection in
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

## Building the TLS config

Loading certificates mirrors the snippet in the crate README.  Install the
`ring` provider then parse your files with `rustls_pemfile`:

```rust,no_run
use rustls::ServerConfig;
use rustls::pki_types::{CertificateDer, PrivateKeyDer};
use std::fs::File;
use std::io::BufReader;

rustls::crypto::ring::default_provider().install_default()
    .expect("install ring provider");

let cert_file = File::open("server.crt")?;
let key_file  = File::open("server.key")?;

let cert_chain = rustls_pemfile::certs(&mut BufReader::new(cert_file))
    .map(|cd| cd.map(CertificateDer::from))
    .collect::<Result<Vec<_>, _>>()?;

let key = rustls_pemfile::read_one(&mut BufReader::new(key_file))?
    .map(|p| match p {
        rustls_pemfile::Item::Pkcs1Key(k) => PrivateKeyDer::Pkcs1(k),
        rustls_pemfile::Item::Pkcs8Key(k) => PrivateKeyDer::Pkcs8(k),
        _ => panic!("unexpected key type"),
    })
    .expect("private key");

let tls_config = ServerConfig::builder()
    .with_no_client_auth()
    .with_single_cert(cert_chain, key)
    .expect("TLS config");
```

`howls` performs the TLS handshake using `tokio_rustls::TlsAcceptor` and serves
HTTP/1.1 responses. WebSocket upgrades are not supported over TLS yet.

For a complete certificate loading example see the
[README](../ohkami-0.24/README.md#tls).
