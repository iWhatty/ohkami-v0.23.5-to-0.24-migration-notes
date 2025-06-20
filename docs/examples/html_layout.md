# HTML Layout with UIbeam

Uses the `uibeam` crate to compose a small HTML UI and wrap each response in a
layout template.  Querying `/?init=5` shows a counter starting at 5 that can be
incremented or decremented using simple JavaScript.

Run:

```bash
$ cargo run --example html_layout
```

Then open `http://localhost:5555` in a browser.
