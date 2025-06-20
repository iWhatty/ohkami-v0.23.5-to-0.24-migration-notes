# Static File Serving

Demonstrates the `Dir` fang for serving files from a directory.  Options enable
hiding dotfiles, omitting `.html` extensions and using precompressed files when
available.  Extensive tests cover the behavior under different settings.

```bash
$ cargo run --example static_files
```

Access files under `public/` such as `/index.html` or `/blog/second.html`.
