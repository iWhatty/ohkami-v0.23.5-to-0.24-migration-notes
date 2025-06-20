# Static File Serving

Demonstrates the `Dir` fang for serving files from a directory.  Options enable
hiding dotfiles, omitting `.html` extensions and using precompressed files when
available.  Extensive tests cover the behavior under different settings.

## Files

- `src/main.rs` – configures the `Dir` fang and contains unit tests.
- `public/` – folder of sample files, some of which have precompressed variants.

### `src/main.rs`

`ohkami()` builds an `Ohkami` instance based on provided `Options`.
The main function simply calls `ohkami(Default::default())` to start a static
file server on port 3000.

```bash
$ cargo run --example static_files
```

Access files under `public/` such as `/index.html` or `/blog/second.html`.
