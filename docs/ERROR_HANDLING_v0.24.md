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

## Logging Failures

Fangs or handlers may log errors using the macros from
[`util.rs`](../ohkami-0.24/ohkami/src/util.rs) such as `ERROR!` or `WARNING!`.

Error handling keeps your API consistent and makes unit tests straightforward
because every failure path yields a deterministic `Response`.
