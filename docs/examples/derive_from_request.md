# Custom `FromRequest` Example

This example demonstrates implementing the [`FromRequest`]
(../../ohkami-0.24/ohkami/src/request/from_request.rs) trait to pull
values out of the incoming [`Request`](../../ohkami-0.24/ohkami/src/request/mod.rs).
It shows a few patterns for borrowing or owning data and how the
`#[derive(FromRequest)]` macro can compose them.

## Files

- `src/main.rs` – manual and derived `FromRequest` implementations.

### `src/main.rs`

The example defines small wrappers around the request method and path:

```rust
struct RequestMethod(Method);
impl<'req> FromRequest<'req> for RequestMethod {
    type Error = std::convert::Infallible;
    fn from_request(req: &'req Request) -> Option<Result<Self, Self::Error>> {
        Some(Ok(Self(req.method)))
    }
}

struct RequestPath<'req>(std::borrow::Cow<'req, str>);
impl<'req> FromRequest<'req> for RequestPath<'req> {
    type Error = std::convert::Infallible;
    fn from_request(req: &'req Request) -> Option<Result<Self, Self::Error>> {
        Some(Ok(Self(req.path.str())))
    }
}

struct RequestPathOwned(String);
impl<'req> FromRequest<'req> for RequestPathOwned {
    type Error = std::convert::Infallible;
    fn from_request(req: &'req Request) -> Option<Result<Self, Self::Error>> {
        Some(Ok(Self(req.path.str().into())))
    }
}
```

These are combined into structs using the derive macro:

```rust
#[derive(FromRequest)]
struct MethodAndPathA {
    method: RequestMethod,
    path:   RequestPathOwned,
}

#[derive(FromRequest)]
struct MethodAndPathB<'req> {
    method: RequestMethod,
    path:   RequestPath<'req>,
}

#[derive(FromRequest)]
struct MethodAndPathC(RequestMethod, RequestPathOwned);

#[derive(FromRequest)]
struct MethodAndPathD<'req>(RequestMethod, RequestPath<'req>);
```

No routes are defined – compiling validates the derive logic. Run it with:

```bash
$ cargo run --example derive_from_request
```
