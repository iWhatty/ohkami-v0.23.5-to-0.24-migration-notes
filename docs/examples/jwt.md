# JWT Authentication Example

Shows how to issue and verify JSON Web Tokens. The secret key is read from
`JWT_SECRET` using `dotenvy`. `/auth` returns a signed token and `/private`
requires that token in the `Authorization` header.

## Files

- `src/main.rs` – issues tokens and validates them on a private route.
- `.env.sample` – example of the required `JWT_SECRET` variable.

### `src/main.rs`

- `jwt()` builds the `JWT` fang with `JWT::default` (HMAC-SHA256).
- `auth` creates a token with a 24h expiry and a `sub` claim provided by a trait.
- `private` extracts the verified `JwtPayload` via `Context`.

See the [source](../../ohkami-0.24/examples/jwt/src/main.rs) for details.

```bash
$ JWT_SECRET=mysecret cargo run --example jwt
```

The included test `test_large_jwt` demonstrates issuing a very large payload.
Run it with `OHKAMI_REQUEST_BUFSIZE=4096` or greater.
