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
All attributes are optional and the methods return the builder so calls can be
chained.  Available helpers include:

- `Expires(datetime)` – absolute expiry as a string, e.g. from
  `ohkami::util::imf_fixdate`.
- `MaxAge(seconds)` – relative lifetime in seconds.
- `Domain(domain)` and `Path(path)` – scope the cookie.
- `Secure()` and `HttpOnly()` – toggle those flags.
- `SameSiteLax()`, `SameSiteNone()` and `SameSiteStrict()`.

```rust
res.headers.set().SetCookie("id", "42", |c| c.Path("/").SameSiteLax());
```

To read `Set-Cookie` headers from a `Response` use the iterator:
```rust
for c in res.headers.SetCookie() {
    println!("{} = {}", c.Cookie().0, c.Cookie().1);
}
```

Each item is parsed with `SetCookie::from_raw` so invalid directives are ignored
in debug builds with a warning. You can also parse a single header manually:

```rust
use ohkami::header::SetCookie;

let raw = "user=xyz; HttpOnly; Max-Age=30";
let sc = SetCookie::from_raw(raw)?;
assert_eq!(sc.MaxAge(), Some(30));
```

### Reading Cookies

Incoming requests expose a `Cookies()` helper that splits the raw `Cookie`
header into `(name, value)` pairs using
[`util::iter_cookies`](../ohkami-0.24/ohkami/src/util.rs):

```rust
for (name, val) in req.headers.Cookies() {
    println!("{name} = {val}");
}
```


## Entity Tags
`ETag` parses strong and weak entity tags. Use `ETag::parse` or the iterator
helpers to process conditional request headers. `ETag::iter_from` skips invalid
values and `try_iter_from` returns errors. The `matches` method implements the
weak comparison defined by HTTP.
It also implements `Display` so headers can be generated with
`res.headers.set().ETag(etag.clone());`

### Example

```rust
use ohkami::header::ETag;

let ours = ETag::strong("v1".into());
for tag in ETag::iter_from(r#"W/"v1", "v2""#) {
    if tag.matches(&ours) {
        // send 304 Not Modified
    }
}
```

## Content Encoding

`Encoding` and `CompressionEncoding` represent compression algorithms. The
`AcceptEncoding` struct sorts algorithms by quality values (`QValue`) so you can
negotiate compressed responses.
`AcceptEncoding::parse` handles `*` wildcards and ignores unknown names.
It defaults `identity` to q=0.001 so compression is preferred if supported.
The helper `QValue::parse` converts a quality string like `"0.8"` into a sortable floating
point representation. Call `iter_in_preferred_order` to iterate encodings
sorted by quality.

Typed helpers exist for many common headers.  For example `ResponseHeaders`
provides methods like `ContentType` and `CacheControl` which accept strongly
typed wrappers.  Implement `FromHeader` for your own types to parse custom
headers on incoming requests.

### Precompressed Files

`CompressionEncoding::from_file_path` detects algorithms from file extensions.
It returns the remaining path with extensions removed so pre-compressed assets
like `app.js.gz.br` can be served with the correct `Content-Encoding` header.
`Dir` uses this helper to look up files preferred by `Accept-Encoding`.

`CompressionEncoding` can also reconstruct names:

- `to_extension()` turns the encoding list back into a file extension such as
  `"gz.br"`.
- `to_content_encoding()` returns the header string like `"gzip, br"`.

```rust
use ohkami::header::CompressionEncoding;
use std::path::Path;

let (enc, path) = CompressionEncoding::from_file_path(Path::new("app.js.gz.br"))
    .unwrap();
assert_eq!(path.as_path(), Path::new("app.js"));
assert_eq!(enc.to_extension(), "gz.br");
assert_eq!(enc.to_content_encoding(), "gzip, br");
```

### Example

Using `AcceptEncoding` to choose a compression scheme:

```rust
use ohkami::header::{AcceptEncoding, Encoding};

if let Some(raw) = req.headers.AcceptEncoding() {
    let ae = AcceptEncoding::parse(raw);
    if matches!(ae.iter_in_preferred_order().next(), Some(Encoding::Gzip)) {
        res.headers.set().ContentEncoding("gzip");
    }
}
```

`AcceptEncoding::accepts` and `accepts_compression` let you test if
the client accepts a particular encoding.
For precompressed files you might do:
```rust
if !ae.accepts_compression(&CompressionEncoding::Single(Encoding::Brotli)) {
    return Response::NotAcceptable();
}
```

Generating an `ETag` for caching:

```rust
use ohkami::header::ETag;

let etag = ETag::weak("v1".into());
res.headers.set().ETag(etag.clone());
```

## Custom Typed Headers

The [`typed::header`](../ohkami-0.24/ohkami/src/typed/header.rs) module
defines wrappers for many standard headers.
They implement `FromRequest` so handlers can declare the headers they
need and validation happens automatically.
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

`Cookie` is a specialized wrapper that deserializes the header into a
struct using `serde`. This makes reading structured cookies trivial.
