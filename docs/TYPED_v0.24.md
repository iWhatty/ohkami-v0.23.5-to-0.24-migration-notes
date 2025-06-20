# Typed Utilities

The [`typed`](../ohkami-0.24/ohkami/src/typed) module provides common HTTP pieces as strongly typed structs.

## Status Types

`typed::status` defines functions like `OK`, `Created`, and `NoContent` which return wrappers implementing `IntoResponse`. Returning these from handlers ensures consistent headers and is clearer than manually constructing a `Response`.

```rust
use ohkami::typed::status;

async fn created() -> status::Created<&'static str> {
    status::Created("ok")
}
```

## Header Extraction

`typed::header` declares the `FromHeader` trait used to parse custom types from request headers. When the `openapi` feature is enabled these types also implement `Schema` for documentation generation.

Implement `FromHeader` for your own structs to automatically fail the request when parsing fails.
