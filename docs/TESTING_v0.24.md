# Testing Helpers

Under debug builds Ohkami provides a lightweight test harness.
It lives in the [`testing`](../ohkami-0.24/ohkami/src/testing/mod.rs) module.
It lets you exercise routes without opening sockets.

Create your application and call `.test()` on it to get a `TestingOhkami` instance.
The [`Testing` trait](../ohkami-0.24/ohkami/src/testing/mod.rs#L41-L52) adds this
method. Use `TestRequest` to build requests and `.oneshot()` to execute them.

```rust
use ohkami::prelude::*;
use ohkami::testing::*;

fn app() -> Ohkami {
    Ohkami::new("/".GET(|| async { "hi" }))
}

#[tokio::test]
async fn test_index() {
    let res = app().test()
        .oneshot(TestRequest::GET("/")).await;
    assert_eq!(res.status(), Status::OK);
    assert_eq!(res.text(), Some("hi"));
}
```

### Building requests

`TestRequest` supplies constructors for each HTTP method and builder helpers for
query parameters and headers
[`(testing/mod.rs#L118-L146)`](../ohkami-0.24/ohkami/src/testing/mod.rs#L118-L146).
When testing JSON or other bodies, `json`, `json_lit` and `content`
automatically set `Content-Type` and `Content-Length`
[(testing/mod.rs#L148-L175)](../ohkami-0.24/ohkami/src/testing/mod.rs#L148-L175).

```rust
let req = TestRequest::POST("/users")
    .query("page", "1")
    .header("X-Token", "abcd")
    .json(&serde_json::json!({"name": "akira"}));
```

### Inspecting responses

`oneshot` returns a `TestResponse` which exposes status, headers and body
helpers. Methods like `header`, `headers`, `text`, `html` and
`json`
[(testing/mod.rs#L188-L231)](../ohkami-0.24/ohkami/src/testing/mod.rs#L188-L231)
verify the reply and ensure `Content-Length` matches the payload.

```rust
let res = app().test().oneshot(req).await;
assert_eq!(res.header("X-Token"), Some("abcd"));
assert_eq!(res.json::<serde_json::Value>().unwrap()["name"], "akira");
```

The testing module is compiled only when `debug_assertions` are enabled.
The harness is unavailable in release builds.
