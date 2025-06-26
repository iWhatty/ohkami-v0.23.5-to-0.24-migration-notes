# Static Directory Serving

Ohkami ships with a built-in `Dir` fang for serving files from a directory on
native runtimes. It lives in
[`ohkami/src/ohkami/dir.rs`](../ohkami-0.24/ohkami/src/ohkami/dir.rs) and is
enabled automatically when you use the `rt_*` features.

`Dir` mounts a folder at a path and responds with files beneath that folder. When
the fang is created the directory is scanned and every file is opened. This means
no filesystem work happens during each request. `Dir` automatically sets
`Content-Type`, `ETag` and `Last-Modified` headers and understands pre-compressed
files such as `.gz`, `.br` and `.zst`.

## Basic Usage

```rust,no_run
use ohkami::prelude::*;

#[tokio::main]
async fn main() {
    Ohkami::new((
        "/".Dir("./public"),
    )).howl("0.0.0.0:3030").await;
}
```

## Options

`Dir` exposes a few builder methods:

- `.serve_dotfiles(bool)` – allow files starting with a dot (`.`). Defaults to `false`.
- `.omit_extensions(&["html"])` – hide specific extensions so requests for
  `/index` serve `index.html`.
- `.etag(fn(&File) -> String)` – supply a custom function to generate an `ETag` value.

Example `ETag` generator using SHA-256:

```rust
fn sha_etag(file: &File) -> String {
    use sha2::{Digest, Sha256};
    let mut hasher = Sha256::new();
    std::io::copy(&mut &*file.try_clone().unwrap(), &mut hasher).unwrap();
    format!("\"{:x}\"", hasher.finalize())
}
```

Pre-compressed files with extensions like `.gz` or `.br` are preferred when the
client sends an `Accept-Encoding` header. Outdated compressed files older than
the source are ignored and the remaining options are tried from smallest to
largest. If none match and the client forbids `identity`, the handler returns
**406 Not Acceptable**.

Caching headers are respected: matching `If-None-Match` or `If-Modified-Since`
results in **304 Not Modified**.

`Dir` only works on native runtimes because Workers cannot access the local
filesystem. When targeting Cloudflare Workers consider using Wrangler's `asset`
feature instead.

## Example with Options

```rust,no_run
use ohkami::prelude::*;

#[tokio::main]
async fn main() {
    Ohkami::new((
        "/".Dir("./public")
            .omit_extensions(&["html"])
            .serve_dotfiles(true),
    )).howl("0.0.0.0:3000").await;
}
```

This serves `index.html` at `/` and `/about.html` at `/about`. Dotfiles under
`./public` are accessible.
