# OpenAPI Support

The optional `openapi` feature integrates specification generation directly into Ohkami.
It builds on the `ohkami_openapi` crate and a set of procedural macros.

With the feature enabled you can annotate data structures with
`#[derive(openapi::Schema)]` and mark handlers using the `#[openapi::operation]`
attribute.  When an application calls `Ohkami::generate` the router walks all
registered routes and produces an `openapi.json` file describing the API.

```rust,ignore
use ohkami::prelude::*;
use ohkami::typed::status;
use ohkami::openapi;

#[derive(Deserialize, openapi::Schema)]
struct CreateUser<'req> {
    name: &'req str,
}

#[derive(Serialize, openapi::Schema)]
#[openapi(component)]
struct User {
    id: usize,
    name: String,
}

#[openapi::operation({ summary: "create a new user" })]
async fn create_user(
    JSON(CreateUser { name }): JSON<CreateUser<'_>>
) -> status::Created<JSON<User>> {
    status::Created(JSON(User { id: 42, name: name.to_string() }))
}

async fn list_users() -> JSON<Vec<User>> {
    JSON(vec![])
}

fn app() -> Ohkami {
    Ohkami::new((
        "/users".GET(list_users).POST(create_user)
    ))
}

#[tokio::main]
async fn main() {
    let o = app();
    o.generate(openapi::OpenAPI {
        title:   "Users API",
        version: "0.1.0",
        servers: &[openapi::Server::at("localhost:5000")],
    });
    o.howl("localhost:5000").await;
}
```

`generate_to` writes the document to an arbitrary path.  On Cloudflare Workers
use the `scripts/workers_openapi.js` helper to run this logic outside of the
`wasm32` environment.

The resulting JSON follows the OpenAPI 3.1 specification and includes schemas,
parameters, request bodies and responses extracted from your handlers.  Manual
edits are rarely necessary once the macros are in place.
