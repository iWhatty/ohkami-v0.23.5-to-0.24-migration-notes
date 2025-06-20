# JWT Authentication Example

Generates JSON Web Tokens and secures a private route using the `JWT` fang.
Set `JWT_SECRET` in `.env` and run the example to obtain a token from `/auth`.
Use that token in the `Authorization` header to access `/private`.

```bash
$ JWT_SECRET=mysecret cargo run --example jwt
```

The included tests show handling large payloads and precompressed files.
