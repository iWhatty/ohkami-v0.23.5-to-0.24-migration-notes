# Error Handling

Ohkami handlers can return `Result<T, E>` where `E` implements `IntoResponse`.
This allows custom error types to map directly to HTTP responses.  The
`response` module provides an `IntoResponse` trait used throughout the
framework.

## Defining Error Types

Create an enum of possible failures and implement `IntoResponse`.  Use typed
status helpers from `typed::status` to keep responses uniform.

```rust
use ohkami::{Response, IntoResponse};
use ohkami::typed::status;

enum MyError {
    Db(sqlx::Error),
    NotFound,
}

impl IntoResponse for MyError {
    fn into_response(self) -> Response {
        match self {
            Self::Db(_) => status::InternalServerError(()).into_response(),
            Self::NotFound => status::NotFound(()).into_response(),
        }
    }
}
```

Handlers simply return `Result<T, MyError>` and the framework converts the
result automatically:

```rust,no_run
async fn fetch_user(id: u32) -> Result<String, MyError> {
    if id == 0 { return Err(MyError::NotFound); }
    Ok("user".into())
}
```

## Using `thiserror`

The [`thiserror`](https://crates.io/crates/thiserror) crate can reduce
boilerplate when mapping errors.  Derive `Error` and use `#[from]` to convert
inner types:

```rust,ignore
#[derive(thiserror::Error, Debug)]
enum MyError {
    #[error("db error: {0}")]
    Db(#[from] sqlx::Error),
}
```

### Simple String Errors

For short messages the [`ErrorMessage`](../ohkami-0.24/ohkami/src/util.rs)
type implements `IntoResponse` out of the box. Returning `ErrorMessage("oops".into())`
produces a **500 Internal Server Error** with the text body:

```rust,no_run
use ohkami::util::ErrorMessage;

async fn handler() -> Result<(), ErrorMessage> {
    Err(ErrorMessage("something failed".into()))
}
```

### Extraction Failures

Custom extractors implementing `FromRequest` or `FromParam` can specify an
`Error` associated type that also implements `IntoResponse`. When extraction
fails the framework calls `into_response` on that error and aborts the handler:

```rust,no_run
use ohkami::{FromRequest, Request, Response};

struct ApiKey(String);
impl<'r> FromRequest<'r> for ApiKey {
    type Error = Response;
    fn from_request(req: &'r Request) -> Option<Result<Self, Self::Error>> {
        req.headers.get("x-api-key")
            .map(|k| Ok(ApiKey(k.to_owned())))
            .or(Some(Err(Response::Unauthorized())))
    }
}
```

## Logging Failures

Fangs or handlers may log errors using the macros from
[`util.rs`](../ohkami-0.24/ohkami/src/util.rs) such as `ERROR!` or `WARNING!`.

Error handling keeps your API consistent and makes unit tests straightforward
because every failure path yields a deterministic `Response`.
