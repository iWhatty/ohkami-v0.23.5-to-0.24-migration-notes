# Custom `FromRequest` Example

Illustrates implementing the `FromRequest` trait to extract custom types from an
incoming request.  Four structs demonstrate different patterns for borrowing or
owning pieces of the request such as the method and path.

This is a compile‑time demo; run with:

```bash
$ cargo run --example derive_from_request
```
