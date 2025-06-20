# Procedural Macros

The `ohkami_macros` crate implements several derive and attribute macros used throughout Ohkami.
Source code lives under [`ohkami_macros/src`](../ohkami-0.24/ohkami_macros/src).

## Serialization Helpers

`Serialize` and `Deserialize` are thin re-exports of the matching `serde` derives. Use them when you want serialization without depending directly on `serde` in your crate.

## Request Extraction

`#[derive(FromRequest)]` generates implementations for extracting typed data from an incoming `Request`. Structs composed of other `FromRequest` types can use this derive to bundle multiple parameters together.

## OpenAPI Integration

With the `openapi` feature enabled, `#[derive(Schema)]` and the `#[operation]` attribute generate OpenAPI schemas and operation metadata from your types and handler functions.

## Cloudflare Workers Support

When targeting Cloudflare Workers, the `worker` attribute connects an `async` function as the entry point and `DurableObject` marks a struct for use with Durable Objects. These rely on the `worker` runtime crate.

`#[bindings]` reads your `wrangler.toml` and generates a struct containing Cloudflare
environment bindings.  This removes boilerplate when accessing KV stores or other
resources from Workers code.

The internal `consume_struct` macro is used by some derives and generally is not
needed directly by applications.

These macros reduce boilerplate and keep your application code focused on business logic.

