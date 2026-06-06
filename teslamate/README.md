# TeslaMate

## Initial setup

### Basic auth (teslamate.alexandcarmen.com)

Create a 1Password item `TeslaMate` under the NAS vault with:
- `username` — the login username
- `password` — the plaintext password (used by the browser extension for autofill)
- `hash` — a bcrypt hash of the password, generated with:

      docker run --rm -it ghcr.io/caddybuilds/caddy-cloudflare:latest caddy hash-password

Then run `./manage inject caddy` to inject the updated secrets before reloading Caddy.
