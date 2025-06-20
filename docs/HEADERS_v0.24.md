# Working with Headers

The [`header`](../ohkami-0.24/ohkami/src/header) module provides helpers for
common HTTP header values.  These utilities simplify parsing and building
headers so you rarely need to manipulate strings directly.

## Append Helper

`append` allows combining values when setting a header:

```rust
res.headers.set().Server(append("ohkami"));
```

Multiple calls join the values with commas according to the HTTP spec.

## Cookie Builder

`SetCookie` exposes a builder style API for generating `Set-Cookie` headers.
All attributes like `MaxAge`, `Domain`, `Secure` and `SameSite` are optional and
can be chained.

```rust
res.headers.set().SetCookie("id", "42", |c| c.Path("/").SameSiteLax());
```

## Entity Tags

`ETag` parses strong and weak entity tags.  Use `ETag::parse` or the iterator
helpers to process conditional request headers.

## Content Encoding

`Encoding` and `CompressionEncoding` represent compression algorithms. The
`AcceptEncoding` struct sorts algorithms by quality values (`QValue`) so you can
negotiate compressed responses.

Typed helpers exist for many common headers.  For example `ResponseHeaders` has
methods like `ContentType` and `CacheControl` which accept strongly typed
wrappers.  Implement `FromHeader` for your own types to parse custom headers on
incoming requests.



