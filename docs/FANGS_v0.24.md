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
`Authorization` header.  Supplying `[BasicAuth; N]` lets you accept several
username/password pairs.

```rust,no_run
use ohkami::fang::BasicAuth;

let secure = ohkami::Ohkami::new((
    BasicAuth { username: "admin", password: "secret" },
    "/".GET(private_handler),
));
```

When the `openapi` feature is active the fang marks protected handlers with a
basic authentication requirement. The implementation at
[lines 99‑103](../ohkami-0.24/ohkami/src/fang/builtin/basicauth.rs#L99-L103)
adds `SecurityScheme::Basic("basicAuth")` to the OpenAPI spec.

## JWT

`JWT::<Payload>::new_256(secret)` verifies a JSON Web Token and stores the
parsed payload in the request context.  Other helpers `new_384` and `new_512`
select different HMAC algorithms.  Customize the token lookup using
`get_token_by`.

```rust,no_run
use ohkami::fang::JWT;

#[derive(serde::Serialize, serde::Deserialize)]
struct Claims { sub: String }

let api = ohkami::Ohkami::new((
    JWT::<Claims>::new_256("topsecret"),
    "/profile".GET(profile),
));
// issue a token for a user
let token = JWT::<Claims>::new_256("topsecret")
    .issue(Claims { sub: "u1".into() });
```

With `openapi` enabled the fang inserts a bearer security definition. The logic
is implemented around
[lines 116‑128](../ohkami-0.24/ohkami/src/fang/builtin/jwt.rs#L116-L128).

## CORS

`CORS::new(origin)` configures `Access-Control-*` headers for cross origin
requests.  Methods like `.AllowCredentials()` and `.AllowHeaders([...])`
customize the response to pre‑flight and normal requests.  Use
`ExposeHeaders` and `MaxAge` to tune caching behavior.  The allowed methods
list is detected automatically from the routes defined at that path.

```rust,no_run
use ohkami::fang::CORS;

let o = ohkami::Ohkami::new((
    CORS::new("https://example.com").AllowCredentials(),
    "/api".GET(handler),
));
// allow caching and expose custom headers
let cors = CORS::new("https://example.com")
    .ExposeHeaders(["X-My-Header"]).MaxAge(600);
```

## Timeout

`Timeout::by_secs(n)` aborts handlers that take longer than the specified
duration on native runtimes.  Builders `by_millis`, `by_secs_f32` and
`by_secs_f64` are also available.

The constructor methods are defined in
[timeout.rs](../ohkami-0.24/ohkami/src/fang/builtin/timeout.rs#L36-L52).

```rust,no_run
use ohkami::fang::Timeout;

Ohkami::new((Timeout::by_secs(10),
    "/slow".GET(slow_handler),
));
```

## Enamel

`Enamel` adds a collection of security headers such as
`Cross-Origin-Embedder-Policy` and `X-Frame-Options`. Start with
`Enamel::default()` and override fields using builder methods like
`CrossOriginResourcePolicy` or `ContentSecurityPolicy`.
Provide a full `ContentSecurityPolicy` using the `CSP` helper and its
`sandbox` and `src` modules for typed configuration.

These fangs can be combined when building an `Ohkami` instance. Refer to the
source files under `fang/builtin` for additional options and examples.
