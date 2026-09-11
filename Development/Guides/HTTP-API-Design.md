# HTTP API Design Notes

Standalone note. No links in or out.

## REST Conventions

- Nouns not verbs: GET /orders, POST /orders, not /getOrders.
- Nest one level deep max: /orders/{id}/items, deeper gets flat query params.
- Version in path: /v1/orders. Never break v1, ship v2.

## Status Codes

- 200 OK with body, 201 Created with Location header, 204 No Content.
- 400 bad input, 401 missing auth, 403 no permission, 404 no such resource.
- 409 conflict on duplicates, 422 valid JSON but bad semantics.
- 429 rate limited with Retry-After, 500 server fault with incident id.

## Pagination and Filtering

```http
GET /orders?status=paid&sort=-total&page=2&per_page=50
```

- Cursor pagination for feeds, offset for admin tables.
- Always cap page size server-side.

## Errors Shape

```json
{ "code": "order_not_found", "message": "No order 42", "trace": "abc123" }
```

- Stable machine code plus human message plus trace id.
- Never leak stack traces or SQL to clients.

## Auth Basics

- Bearer tokens over HTTPS, short expiry, refresh rotation.
- API keys in header, never in URL query.
- Rate limit per key, log every 401 and 403.

## Gotchas

- PUT replaces whole resource, PATCH changes fields.
- DELETE returns 204 or 200 with the deleted id echo.
- Timestamps in UTC ISO8601, always with timezone.


