# Testing Helpers

Under debug builds Ohkami exposes a lightweight test harness in the [`testing`](../ohkami-0.24/ohkami/src/testing/mod.rs) module. It allows exercising routes without opening sockets.

Create your application and call `.test()` on it to get a `TestingOhkami` instance. Use `TestRequest` to build requests and `.oneshot()` to execute them.

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

`TestRequest` supports adding query parameters, headers and JSON bodies for exercising your handlers.
