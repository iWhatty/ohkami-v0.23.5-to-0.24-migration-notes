# Multipart Form Handling

Shows how to receive multipart form data including uploaded files.  Submitting
the provided `form.html` sends text and multiple images to the `/submit` route.
A simple `Logger` fang prints each request and response for clarity.

Build and run:

```bash
$ cargo run --example form
```

Open `http://localhost:5000/form` in a browser to test file uploads.
