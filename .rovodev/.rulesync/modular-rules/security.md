# Security Rules

These principles apply regardless of framework, language runtime, or hosting environment. Translate them to the project's actual stack.

---

## Authentication

- Validate credentials/tokens on every request. Never trust client-supplied identity without server-side verification.
- Use cryptographically secure random values for tokens, session IDs, and secrets (e.g., `crypto.randomBytes` in Node.js or the platform equivalent).
- Enforce token expiry and support revocation.
- Transmit credentials only over encrypted channels (HTTPS/TLS).

---

## Authorization

- Check that the authenticated identity has permission to perform the requested operation — for every operation, not just at login.
- Do not rely on obscurity (hidden routes, client-side guards) as the sole authorization mechanism.
- Apply the principle of least privilege: grant access only to what is needed, nothing more.
- Verify ownership before mutating or returning a resource (e.g., confirm the requesting user owns the record before returning or modifying it).

---

## Input validation

- Validate all inputs at every trust boundary — API endpoints, background job handlers, webhook receivers, etc.
- Use the project's established validation library or framework middleware.
- Reject unexpected fields; do not pass raw user input directly to the data layer.
- Apply type coercion before validation, not instead of it.

---

## Data access

- Use parameterized queries or the ORM's safe query builder. Never interpolate user input directly into raw query strings.
- Scope data returned to the client to only what the caller needs. Do not return full records when a subset is sufficient.
- Do not expose internal identifiers, stack traces, or system metadata in error responses.

---

## Secrets and environment

- Store all secrets in environment variables. Never commit credentials, API keys, or tokens to version control.
- Validate that required environment variables are present at startup; fail loudly if they are missing.
- Keep secrets server-side only. Do not pass secrets to the client, even via build-time constants.

---

## Error responses

- Return generic error messages to external callers. Log the full detail server-side.
- Use consistent error shapes — whatever the project's error model is — so callers cannot fingerprint the system from error variance.
- Do not include internal paths, query strings, or dependency versions in error output.
