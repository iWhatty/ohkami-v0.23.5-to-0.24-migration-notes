# Request and Response Formats

Ohkami defines `FromBody` and `IntoBody` traits for converting between raw bytes
and Rust types.  The [`format`](../ohkami-0.24/ohkami/src/format) module contains
common implementations so handlers can work with strongly typed data without
manual parsing.

## Built‑In Types

The `builtin` submodule covers the typical web formats:

- **Query** – deserialize query strings into a struct.
- **JSON** – parse `application/json` payloads with `serde_json`.
- **URLEncoded** – form encoding for `application/x-www-form-urlencoded`.
- **Multipart** – handle `multipart/form-data` uploads.  Files are represented by
  the `File` helper.
- **Text** – plain UTF‑8 bodies.
- **HTML** – convenience wrapper for returning HTML responses.

Each type implements both `FromBody` and `IntoBody` so they can be used for
request extraction and response generation.  With the `openapi` feature enabled
these types also provide schema information for documentation.

## Custom Formats

Applications can define their own structures by implementing the two traits.
`FromBody` specifies a `MIME_TYPE` and a conversion from `&[u8]` while
`IntoBody` supplies the outgoing `CONTENT_TYPE` and a method to serialize to
bytes.

For JSON data most handlers accept or return `format::JSON<T>` where `T` is a
`serde` serializable type.  Multipart uploads expose files using the `File`
struct which includes filename and content type metadata.  If you need a custom
encoding such as protocol buffers implement both traits and you can seamlessly
use the type in request parameters or responses.

See the source files under `format/builtin/` for simple examples of these
traits in action.




