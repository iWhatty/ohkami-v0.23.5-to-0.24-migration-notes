# Builtin Fangs

Ohkami's middleware system revolves around **fangs**. A fang implements
`FangAction` and can run code before and after a request handler.  The
[`fang::builtin`](../ohkami-0.24/ohkami/src/fang/builtin) module ships
several ready‑made fangs which cover common needs.

## Context

`Context::new(value)` stores arbitrary data for the lifetime of each request.
Handlers can retrieve it by accepting `Context<'_, T>` as a parameter.
This is useful for passing database pools or other shared resources.

```rust,no_run
use ohkami::fang::Context;

fn app(pool: sqlx::PgPool) -> ohkami::Ohkami {
    ohkami::Ohkami::new((
        Context::new(pool),
        "/users".GET(list_users),
    ))
}
```

## BasicAuth

`BasicAuth { username, password }` guards routes using the HTTP
`Authorization` header.  Multiple credentials can be provided via an array.

```rust,no_run
use ohkami::fang::BasicAuth;

let secure = ohkami::Ohkami::new((
    BasicAuth { username: "admin", password: "secret" },
    "/".GET(private_handler),
));
```

## JWT

`JWT::<Payload>::new_256(secret)` verifies a JSON Web Token and stores the
parsed payload in the request context.  Customize the retrieval of the token
with `with_getter`.

```rust,no_run
use ohkami::fang::JWT;

#[derive(serde::Serialize, serde::Deserialize)]
struct Claims { sub: String }

let api = ohkami::Ohkami::new((
    JWT::<Claims>::new_256("topsecret"),
    "/profile".GET(profile),
));
```

## CORS

`CORS::new(origin)` configures `Access-Control-*` headers for cross origin
requests.  Methods like `.AllowCredentials()` and `.AllowHeaders([...])`
customize the response to pre‑flight and normal requests.

```rust,no_run
use ohkami::fang::CORS;

let o = ohkami::Ohkami::new((
    CORS::new("https://example.com").AllowCredentials(),
    "/api".GET(handler),
));
```

## Timeout

`Timeout::by_secs(n)` aborts handlers that take longer than the specified
duration on native runtimes.

```rust,no_run
use ohkami::fang::Timeout;

Ohkami::new((Timeout::by_secs(10),
    "/slow".GET(slow_handler),
));
```

## Enamel

`Enamel` adds a collection of security headers such as
`Cross-Origin-Embedder-Policy` and `X-Frame-Options`. Use
`Enamel::default()` and override fields as needed.

These fangs can be combined when building an `Ohkami` instance.  Refer to the
source files under `fang/builtin` for additional options and examples.
