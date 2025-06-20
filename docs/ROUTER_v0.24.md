# Router Internals

Routing logic lives in [`router`](../ohkami-0.24/ohkami/src/router).  A tree of
`Node` structures represents path segments for each HTTP method.  Handlers are
registered with a path like `/api/users/:id` which creates nested nodes for the
static and parameter segments.

During startup the router is finalized into a lookup table.  Incoming requests
traverse the tree matching segments until reaching a handler.  Middleware (fangs)
registered at higher levels are collected along the way and wrap the handler in
order.

Each HTTP method has its own sub tree so a path can host different handlers for
`GET`, `POST` and others.  Parameters are captured by name when traversing nodes
and passed to handlers via `FromParam` implementations.  After building the tree
`finalize()` flattens it into arrays for fast binary search at runtime.

Understanding this structure helps when reading error messages about conflicting
routes or parameter counts.  The public APIs hide these details but the source is
useful if you need to debug complex route setups.



Example tree for nested routes:

```rust,no_run
use ohkami::prelude::*;

async fn get_user(id: u32) -> String { format!("user {id}") }
async fn create_user() -> &'static str { "created" }

#[tokio::main]
async fn main() {
    let api = Ohkami::new((
        "/users".GET(|| async {"list"}).POST(create_user),
        "/users/:id".GET(get_user),
    ));

    Ohkami::new(("/api".By(api))).howl("localhost:5000").await;
}
```

This builds a router with `/api/users` and `/api/users/:id` nodes containing
handlers for `GET` and `POST` methods. The nested structure mirrors the path
segments and allows middleware to be attached at any level.
