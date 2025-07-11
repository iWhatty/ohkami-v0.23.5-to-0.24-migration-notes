# Common Patterns

This note collects useful idioms found throughout the v0.24 source
code.  They can serve as guidelines when designing your own services.

## Nesting Routes

`Ohkami` instances can be nested with `Route::By`.  The inner app is
mounted under a prefix:

```rust
Ohkami::new((
    "/api".By(other_ohkami),
))
```

The outer instance receives requests and delegates to the inner one.

## Custom Extraction

Implement `FromRequest` to pull values from the request.  The
`derive_from_request` example demonstrates structs and tuples derived
from request pieces:

```rust
#[derive(FromRequest)]
struct MethodAndPathA {
    method: RequestMethod,
    path:   RequestPathOwned,
}
```

`from_request` returns `Option<Result<T, E>>` so you may return `None`
to skip extraction for a particular handler.

## Middleware Composition

Fangs are combined as tuples.  The internal `middleware` module defines
`Fangs` for tuples up to eight elements.  When multiple fangs are
present they wrap the handler in order:

```rust
(FangA, FangB, "/route".GET(handler))
```

Here `FangA` runs first, then `FangB`, and finally the handler.

## Testing Without the Network

The library provides a test harness that allows calling handlers without
opening sockets.  Create the `Ohkami` instance and invoke
`ohkami.testing::Test`:

```rust
let t = my_ohkami().test();
let res = t.oneshot(TestRequest::GET("/hello")).await;
```

Responses can be inspected like normal `Response` values.

## Typed Responses

The `typed::status` module defines structs such as `Created` and
`NoContent` for common status codes.  Construct these with or without a
payload to clearly express handler results.

## Builtin Middleware

Ohkami ships with several useful fangs that cover common needs.  They can
be found under [`fang::builtin`](../ohkami-0.24/ohkami/src/fang/builtin):

- `Context` for passing data between fangs and handlers.
- `BasicAuth` and `JWT` for authentication.
- `CORS` to add cross origin headers.
- `Timeout` to stop long running requests.

Combine them as needed when constructing your `Ohkami` instance.

## Real‑time Features

With the `sse` feature enabled an endpoint can stream
Server‑Sent Events using `DataStream`.  The `ws` feature enables building
WebSocket handlers via `WebSocketContext`.

## OpenAPI Generation

Enable the `openapi` feature to have `Ohkami` produce an OpenAPI document
describing all routes.  Call `Ohkami::generate` or `generate_to` before
starting the server to write `openapi.json`.

## Runtime Tuning

Several behaviors can be adjusted via environment variables when using a native runtime:

- `OHKAMI_REQUEST_BUFSIZE` – size of the internal request buffer.
- `OHKAMI_KEEPALIVE_TIMEOUT` – seconds before an idle connection is closed.
- `OHKAMI_WEBSOCKET_TIMEOUT` – lifetime of WebSocket sessions.

Set these higher for large headers or long‑lived WebSocket connections.

## Dependency Injection via Generics

`Context` is generic which enables ergonomic dependency injection. Define a
repository trait and implement it for your concrete database layer. Handlers can
be generic over this trait and receive it through `Context<'_, T>`.

```rust
async fn get_user<R: Repository>(
    id: u32,
    Context(r): Context<'_, R>,
) -> Result<JSON<User>, MyError> {
    let row = r.get_user_by_id(id as i64).await?;
    Ok(JSON(User { id: row.id as u32, name: row.name }))
}
```

Select the implementation when building the application:

```rust
Ohkami::new((
    Context::new(PostgresRepository(pool)),
    "/users".By(users_ohkami::<PostgresRepository>()),
));
```

## Typed Error Handling

Custom error enums can implement `IntoResponse` to convert failures into HTTP
responses. Handlers then return `Result<T, E>` where `E` maps to an
appropriate status code.

```rust
enum MyError {
    Sqlx(sqlx::Error),
}
impl IntoResponse for MyError {
    fn into_response(self) -> Response {
        match self {
            Self::Sqlx(_) => Response::InternalServerError(),
        }
    }
}
```

[thiserror](https://crates.io/crates/thiserror) can help reduce boilerplate for
these conversions.


## Custom Path Parameters

`FromParam` lets handlers accept structured values from route segments.
Implement it on your own type to parse the percent-decoded parameter string:

```rust
use std::borrow::Cow;
use ohkami::{FromParam, Response};

struct HexId(u64);

impl<'p> FromParam<'p> for HexId {
    type Error = Response;

    fn from_param(param: Cow<'p, str>) -> Result<Self, Self::Error> {
        u64::from_str_radix(&param, 16)
            .map(HexId)
            .map_err(|_| Response::BadRequest())
    }
}
```

Apply it directly in a handler:

```rust
async fn show(HexId(id): HexId) -> String {
    format!("0x{id:x}")
}
```

Implement `openapi_param` when the OpenAPI feature is enabled.
This allows the generator to document the parameter schema.

