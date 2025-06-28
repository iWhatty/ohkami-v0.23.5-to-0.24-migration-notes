# Multipart Form Handling

Shows how to receive multipart form data including uploaded files.  Submitting
the provided `form.html` sends text and multiple images to the `/submit` route.
A simple `Logger` fang prints each request and response for clarity.

## Files

- `src/main.rs` – form handler logic.
- `form.html` – sample HTML form.

See [`src/main.rs`](../../ohkami-0.24/examples/form/src/main.rs) and
[`form.html`](../../ohkami-0.24/examples/form/form.html) for the full example.

### `src/main.rs`

The handler uses the `Multipart` wrapper:

```rust
#[derive(Deserialize)]
struct FormData<'req> {
    #[serde(rename = "account-name")]
    account_name: Option<&'req str>,
    pics: Vec<File<'req>>,
}
```

- `get_form` returns the HTML form on `/form`.
- `post_submit` parses a multipart request at `/submit` and logs the result.
- `Logger` fang shows incoming requests and outgoing responses in the console.

Build and run:

```bash
$ cargo run --example form
```

Open `http://localhost:5000/form` in a browser to test file uploads.
