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

Typed status wrappers automatically set `Content-Type` and `Content-Length` based on the body. Use `.with_headers` to attach additional headers:

```rust,no_run
use ohkami::typed::{status, header};

async fn created_user(JSON(user): JSON<User>)
    -> status::Created<JSON<User>>
{
    status::Created(JSON(user))
        .with_headers(|h| h.Location("/users/42"))
}
```

### Custom Header Types

`typed::header` exposes structs like `Authorization`, `ContentType` and `Cookie`. They implement `FromRequest` so handlers simply name the header they need. Custom types implementing [`FromHeader`](../ohkami-0.24/ohkami/src/typed/header.rs) can be used with these wrappers.

```rust,no_run
use ohkami::prelude::*;
use ohkami::typed::{status, header};

struct BearerToken(String);
impl<'r> header::FromHeader<'r> for BearerToken {
    type Error = status::Unauthorized<&'static str>;
    fn from_header(raw: &'r str) -> Result<Self, Self::Error> {
        raw.strip_prefix("Bearer ")
            .map(|t| Self(t.to_owned()))
            .ok_or(status::Unauthorized("invalid token"))
    }
}

async fn api(header::Authorization(BearerToken(token)): header::Authorization<BearerToken>)
    -> &'static str
{
    println!("token: {token}");
    "ok"
}
```

The `Cookie` wrapper works similarly but parses the header into a struct that implements `Deserialize`. See the source for more details.

## Redirect Responses

Several status helpers represent redirects and require a `Location` header. Construct them with the target URL:

```rust,no_run
use ohkami::typed::status;

async fn go_home() -> status::Found {
    status::Found::at("/")
}
```

The `at` and `to` constructors create `Found`, `MovedPermanently`, `TemporaryRedirect` and `PermanentRedirect` types. They implement `IntoResponse` and expose `.with_headers` just like other statuses.

## Empty Body Statuses

For responses that carry no body, types such as `NoContent` and `Accepted` can be returned directly without parameters:

```rust
use ohkami::typed::status;

async fn ping() -> status::NoContent {
    status::NoContent
}
```

These ensure consistent headers while avoiding manual `Response` creation.
