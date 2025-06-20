# Ohkami v0.24 Start-up Guide

This guide walks you through the basics of getting a project running with [Ohkami](https://github.com/ohkami-rs/ohkami) **v0.24**. It focuses on native runtime usage via `tokio`, but the steps are similar for other runtimes.

## Installation

Add Ohkami to your `Cargo.toml` dependencies. The `rt_tokio` feature enables the async runtime support.

```toml
[dependencies]
ohkami = { version = "0.24", features = ["rt_tokio"] }
tokio  = { version = "1", features = ["full"] }
```

If you plan to use TLS, add the `tls` feature as well:

```toml
[dependencies]
ohkami = { version = "0.24", features = ["rt_tokio", "tls"] }
# plus rustls dependencies
```

## Hello Ohkami

Below is a minimal HTTP server that exposes two routes. Save this as `src/main.rs` in your Rust project.

```rust,no_run
use ohkami::prelude::*;
use ohkami::typed::status;

async fn health_check() -> status::NoContent {
    status::NoContent
}

async fn hello(name: &str) -> String {
    format!("Hello, {name}!")
}

#[tokio::main]
async fn main() {
    Ohkami::new((
        "/healthz".GET(health_check),
        "/hello/:name".GET(hello),
    )).howl("localhost:3000").await;
}
```

Run the server:

```bash
$ cargo run
```

Check the endpoints:

```bash
$ curl http://localhost:3000/healthz
$ curl http://localhost:3000/hello/your_name
Hello, your_name!
```

## Exploring More Features

Ohkami provides optional features for WebSocket, Server‑Sent Events, OpenAPI document generation and more. Enable them in `Cargo.toml` and refer to the README in `ohkami-0.24/` for detailed examples.

### TLS Example

Create certificate files and run an HTTPS server:

```bash
$ openssl req -x509 -newkey rsa:4096 -nodes -keyout server.key -out server.crt -days 365 -subj "/CN=localhost"
```

```rust,no_run
use ohkami::prelude::*;
use rustls::ServerConfig;
use rustls::pki_types::{CertificateDer, PrivateKeyDer};
use std::fs::File;
use std::io::BufReader;

async fn hello() -> &'static str {
    "Hello, secure ohkami!"
}

#[tokio::main]
async fn main() -> std::io::Result<()> {
    rustls::crypto::ring::default_provider().install_default()?;

    let cert_file = File::open("server.crt")?;
    let key_file = File::open("server.key")?;

    let cert_chain = rustls_pemfile::certs(&mut BufReader::new(cert_file))
        .map(|cd| cd.map(CertificateDer::from))
        .collect::<Result<Vec<_>, _>>()?;
    let key = rustls_pemfile::read_one(&mut BufReader::new(key_file))?
        .map(|p| match p {
            rustls_pemfile::Item::Pkcs1Key(k) => PrivateKeyDer::Pkcs1(k),
            rustls_pemfile::Item::Pkcs8Key(k) => PrivateKeyDer::Pkcs8(k),
            _ => panic!("Unexpected private key type"),
        })
        .expect("Failed to read private key");

    let tls_config = ServerConfig::builder()
        .with_no_client_auth()
        .with_single_cert(cert_chain, key)
        .expect("Failed to build TLS configuration");

    Ohkami::new((
        "/".GET(hello),
    )).howls("0.0.0.0:8443", tls_config).await;

    Ok(())
}
```

Start the server and access it via HTTPS:

```bash
$ cargo run
$ curl https://localhost:8443 --insecure
Hello, secure ohkami!
```

## Configuration

Several environment variables adjust runtime behavior on native
backends:

- `OHKAMI_REQUEST_BUFSIZE` – request buffer size (default **2048** bytes).
- `OHKAMI_KEEPALIVE_TIMEOUT` – keep‑alive timeout in seconds (default **30**).
- `OHKAMI_WEBSOCKET_TIMEOUT` – WebSocket timeout in seconds (default **3600**).

Increase these values if your service receives large headers or long‑lived WebSocket connections.

## Why Ohkami?

- **Macro‑less APIs**: Intuitive and type‑safe route definitions.
- **Multiple runtimes**: Works with `tokio`, `smol`, `nio`, `glommio`, and cloud runtimes like Workers or Lambda.
- **WebSocket & SSE**: Built‑in asynchronous support.
- **OpenAPI integration**: Generate API docs automatically.
- **High performance**: Minimal overhead with convenient testing tools.

Explore the `examples/` directory under `ohkami-0.24` for more usage patterns. Check the main [README](../ohkami-0.24/README.md) for a comprehensive feature list.

