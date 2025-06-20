# JWT Authentication Example

Generates JSON Web Tokens and secures a private route using the `JWT` fang.
Set `JWT_SECRET` in `.env` and run the example to obtain a token from `/auth`.
Use that token in the `Authorization` header to access `/private`.

## Files

- `src/main.rs` – issues tokens and verifies them on a private route.
- `.env.sample` – example of the required `JWT_SECRET` variable.

### `src/main.rs`

- `jwt()` builds the `JWT` fang with the configured secret.
- `auth` returns a new token from `/auth`.
- `private` demonstrates extracting the validated payload via `Context`.

```bash
$ JWT_SECRET=mysecret cargo run --example jwt
```

The included tests show handling large payloads and precompressed files.
