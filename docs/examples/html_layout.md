# HTML Layout with UIbeam

Uses the `uibeam` crate to compose a small HTML UI and wrap each response in a
layout template.  Querying `/?init=5` shows a counter starting at 5 that can be
incremented or decremented using simple JavaScript.

## Files

- `src/main.rs` – defines the `Layout` fang and a simple counter component.

### `src/main.rs`

- `Layout::fang_with_title` wraps HTML responses with a page template.
- `Counter` is a UIbeam component rendering the interactive counter.
- `index` handler reads an optional `init` query parameter and returns the
  rendered page via `HTML`.

Run:

```bash
$ cargo run --example html_layout
```

Then open `http://localhost:5555` in a browser.
