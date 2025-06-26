# Testing Helpers

Under debug builds Ohkami provides a lightweight test harness.
It lives in the [`testing`](../ohkami-0.24/ohkami/src/testing/mod.rs) module.
It lets you exercise routes without opening sockets.

Create your application and call `.test()` on it to get a `TestingOhkami` instance.
Use `TestRequest` to build requests and `.oneshot()` to execute them.

```rust
use ohkami::prelude::*;
use ohkami::testing::*;

fn app() -> Ohkami {
    Ohkami::new( "/".GET(|| async { "hi" }) )
}

#[tokio::test]
async fn test_index() {
    let res = app().test().oneshot(TestRequest::GET("/")).await;
    assert_eq!(res.status(), Status::OK);
    assert_eq!(res.text(), Some("hi"));
}
```

`TestRequest` can add query parameters or headers.
It also attaches JSON bodies for exercising handlers.

In addition to `query` and `header` there are helpers `json` and `json_lit` for adding bodies.
Use `content` to send arbitrary bytes with a custom type.
`json` takes any `Serialize` value, `json_lit` accepts raw JSON bytes, and
`content` lets you set an arbitrary content type with bytes.

`oneshot` returns a future resolving to `TestResponse`.
Use `status`, `header`, `text`, `html` or `json` to inspect the response.

The testing module is compiled only when `debug_assertions` are enabled.
The harness is unavailable in release builds.
