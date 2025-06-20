# Custom `FromRequest` Example

Illustrates implementing the `FromRequest` trait to extract custom types from an
incoming request.  Four structs demonstrate different patterns for borrowing or
owning pieces of the request such as the method and path.

## Files

- `src/main.rs` – defines several `FromRequest` implementations.

### `src/main.rs`

The example defines wrapper structs (`RequestMethod`, `RequestPath`, etc.) and
derive macros (`MethodAndPathA`–`D`) showing how to borrow from or own pieces of
the incoming request. There are no routes; compiling ensures the derives work.

This is a compile‑time demo; run with:

```bash
$ cargo run --example derive_from_request
```
