# HTML Layout with UIbeam

This example demonstrates server-side HTML rendering using the
[`uibeam`](https://crates.io/crates/uibeam) crate.
A [`Layout`](../../ohkami-0.24/examples/html_layout/src/main.rs#L7-L31)
fang wraps each response in a page template that loads a Tailwind
stylesheet from a CDN.

Querying `/?init=5` shows a counter starting at `5` that can be
incremented or decremented using simple JavaScript.

## Files

- [`src/main.rs`](../../ohkami-0.24/examples/html_layout/src/main.rs)
  defines the `Layout` fang and a `Counter` component.

### Key Pieces

- `Layout::fang_with_title` wraps HTML responses with the template.
- `Counter` renders the interactive counter UI.
- `index` reads an optional `init` query parameter and returns the page
  wrapped in `HTML`.

Run:

```bash
$ cargo run --example html_layout
```

Then open `http://localhost:5555` in a browser.
