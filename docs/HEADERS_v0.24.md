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

The same helper can be used with typed headers such as
`ResponseHeaders::Server` to avoid string concatenation by hand.

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
It also implements `Display` so headers can be generated with
`res.headers.set().ETag(etag.clone());`.

## Content Encoding

`Encoding` and `CompressionEncoding` represent compression algorithms. The
`AcceptEncoding` struct sorts algorithms by quality values (`QValue`) so you can
negotiate compressed responses.
The helper `QValue::parse` converts a quality string like `"0.8"` into a sortable
floating point representation.

Typed helpers exist for many common headers.  For example `ResponseHeaders` has
methods like `ContentType` and `CacheControl` which accept strongly typed
wrappers.  Implement `FromHeader` for your own types to parse custom headers on
incoming requests.




### Example

Using `AcceptEncoding` to choose a compression scheme:

```rust
use ohkami::header::{AcceptEncoding, CompressionEncoding};

if let Some(ae) = req.headers.AcceptEncoding() {
    if ae.preferred() == Some(CompressionEncoding::Gzip) {
        res.headers.set().ContentEncoding("gzip");
    }
}
```

Generating an `ETag` for caching:

```rust
use ohkami::header::ETag;

let etag = ETag::weak("v1".into());
res.headers.set().ETag(etag.clone());
```

## Custom Typed Headers

The [`typed::header`](../ohkami-0.24/ohkami/src/typed/header.rs) module defines wrappers for many standard headers.
They implement `FromRequest` so a handler can declare the headers it needs and validation happens automatically.

You can provide your own parsing logic by implementing `FromHeader` for a custom type:

```rust,no_run
use ohkami::prelude::*;
use ohkami::typed::{header, status};

struct ApiKey(String);
impl<'r> header::FromHeader<'r> for ApiKey {
    type Error = status::Unauthorized<&'static str>;
    fn from_header(raw: &'r str) -> Result<Self, Self::Error> {
        if raw.starts_with("Key ") {
            Ok(ApiKey(raw[4..].to_owned()))
        } else {
            Err(status::Unauthorized("missing key"))
        }
    }
}

async fn protected(header::Authorization(ApiKey(key)): header::Authorization<ApiKey>)
    -> &'static str
{
    println!("key = {key}");
    "ok"
}
```

`Cookie` is a specialized wrapper that deserializes the header into a struct using `serde`. This makes reading structured cookies trivial.
