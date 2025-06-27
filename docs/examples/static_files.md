# Static File Serving

Demonstrates the `Dir` fang for serving files. The example shows how to hide
dotfiles, omit `.html` extensions and send precompressed versions when the client
supports them.

## Files

- `src/main.rs` – configures the `Dir` fang and includes unit tests.
- `public/` – sample files with `.gz` and `.br` variants.

### `src/main.rs`

`ohkami()` builds a server from `Options`:

```rust
fn ohkami(opts: Options) -> Ohkami {
    Ohkami::new((
        "/".Dir("./public")
            .omit_extensions(if opts.omit_dot_html { &["html"] } else { &[] })
            .serve_dotfiles(opts.serve_dotfiles)
            .etag(opts.etag),
    ))
}
```

Running `main` with default options launches on `0.0.0.0:3000`.

Precompressed files such as `sub.js.gz` and `sub.js.br` are preferred depending
on the `Accept-Encoding` header. If none match and identity is forbidden, the
server returns **406 Not Acceptable**. The handler also sets `Last-Modified` and
`ETag` headers so repeated requests can return **304 Not Modified**.

See [`src/main.rs`](../../ohkami-0.24/examples/static_files/src/main.rs) for the
full code.

```bash
$ cargo run --example static_files
```

Access `public/index.html` at `/` or try `/blog/second.html` to see gzip
responses.
