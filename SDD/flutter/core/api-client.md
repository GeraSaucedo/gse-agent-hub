# SDD — API Client & Interceptor Chain

| | |
|---|---|
| **Feature** | HTTP client facade + request/response/error interceptor pipeline |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `new-repository` (repositories consume this client) |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Isolate repositories from the HTTP library behind a client facade, and decorate every request
uniformly (auth, refresh, logging) while normalizing errors into the typed hierarchy.

| In scope | Out of scope |
|---|---|
| Client facade (verbs, generics) | Error → `Failure` mapping (`core/error-handling.md`) |
| Interceptor pipeline + ordering | Refresh *policy* details (`auth/refresh-token.md`) |
| Bearer + refresh + logging | Per-feature endpoints (feature docs) |

### 1.1 Terminology
- **Facade** — a concrete `ApiClient` wrapping `Dio`; repositories depend on it, not on Dio.
- **Interceptor** — a stage observing/mutating a request, response, or error.

---

## 2. Constraints (architectural)

- Repositories depend on the concrete **`ApiClient` facade**, never on `Dio` directly.
- `ApiClient` wraps `Dio` and registers the interceptor pipeline once, at construction.
- The pipeline includes, in order: **refresh → bearer → logger** (refresh must be able to react to
  a `401` and re-drive the request; bearer stamps the token; logger observes).
- Direct-to-storage side channels (presigned uploads) use a **separate, interceptor-free** client.

**Dependencies (pub):** `dio: ^5.9.1`. Logging via a custom `AppLogger` (no `logger` package).

> 🔎 "Repositories use `ApiClient`, not Dio" is the spec. The exact interceptor classes are
> implementation — but their *observable effects* (below) are contract.

---

## 3. Observable Behavior

| Stage | Observable effect | Fails how |
|---|---|---|
| Refresh | On `401`, refreshes the token and **replays** the failed request; queues concurrent calls during refresh; on refresh failure triggers **force-logout** | see `auth/refresh-token.md` |
| Bearer | Adds `Authorization: Bearer <token>` when present | soft — skips if absent |
| Logger | Emits structured request/response/error logs (debug) | never affects the call |

```
request ─►[refresh]─►[bearer]─►[logger]─► Dio ─► response ─►[logger]─► caller
                          ▲                    └─ 401 ─►[refresh: refresh+replay | force-logout]
```

**Extension (ientc):** a **context/location interceptor** may stamp ambient headers
(e.g. geo/locale) read from a **cached** value synchronously — it must **never await device I/O**
and omits headers if no cache exists.

> 🔎 The refresh interceptor is what makes a mid-session `401` self-healing — this is the GSE
> baseline (it resolves the limitation ientc had). See `auth/refresh-token.md`.

---

## 4. Behavioral Flow

1. Repository calls `apiClient.<verb><T>(path, {query, headers, data})`.
2. Request passes the pipeline (refresh guard → bearer → logger).
3. Dio executes with configured timeouts.
4. Success → typed payload returned to the repository.
5. `401` (non-auth endpoint) → refresh interceptor refreshes + replays, or force-logs-out if refresh fails.
6. Other failures → normalized `ApiException` thrown (see `core/error-handling.md`).

---

## 5. Interface

Client facade (generic over response type `T`): `get<T>`, `post<T>`, `put<T>`, `patch<T>`,
`delete<T>` — each `Future<T>`, throwing `ApiException` on error.

Interceptors: standard Dio request/response/error hooks. Refresh interceptor **whitelists** the
auth endpoints (`/login`, `/refresh-token`, `/logout`) so they are never themselves refreshed.

---

## 6. Data Design

- Configurable send/receive timeouts.
- Refresh interceptor holds a transient queue of pending requests during an in-flight refresh
  (single-flight), replayed after a new token is obtained.

---

## 7. Security Considerations

- Bearer/refresh are the only places tokens touch requests; tokens read from secure storage at send time.
- Logging must redact tokens and credential bodies — never log raw auth payloads.
- The interceptor-free upload client must still use HTTPS.

---

## 8. Error Handling

The pipeline **normalizes** transport errors into `ApiException` (owned by `core/error-handling.md`).
A `401` is handled by the refresh interceptor first (refresh + replay); only if refresh fails does
it surface as an unauthorized failure and force-logout.

---

## 9. Acceptance Criteria & Invariants

- **A1.** A call the repository did not add auth to → sent request carries `Bearer <token>` when a token exists.
- **A2.** A `401` on a non-auth endpoint → token is refreshed and the original request is replayed once.
- **A3.** Concurrent calls during a refresh are queued and replayed after the new token — refresh runs once (single-flight).
- **A4.** Refresh failure → force-logout (session → `unauthenticated`); the auth endpoints themselves are never refreshed.
- **A5.** A network/timeout failure reaches the repository as a typed `ApiException`, not a raw `DioException`.
- **A6.** The presigned-upload path sends **without** the bearer/refresh/logger interceptors.

**Invariants**
- **I1.** No repository imports the HTTP library directly.
- **I2.** The context/extension interceptor never awaits device I/O on the request path.
- **I3.** Interceptor order is fixed and identical for every call.

---

## 10. Risks & Open Questions

- **R1.** No generic retry (beyond refresh-driven replay) for transient 5xx. Add bounded backoff for idempotent verbs?
- **R2.** Refresh replay must cap retries to avoid loops if the new token is also rejected.

---

## 11. Traceability / Pairs-with

| Concern | File |
|---|---|
| Client facade | `base_app/lib/core/services/api/dio_client.dart` |
| Refresh interceptor | `base_app/lib/core/services/api/interceptors/refresh_token_interceptor.dart` |
| Bearer interceptor | `base_app/lib/core/services/api/interceptors/bearer_token_interceptor.dart` |
| Logger interceptor | `base_app/lib/core/services/api/interceptors/logger_interceptor.dart` |
| Error mapping | `base_app/lib/core/services/api/error_mapping.dart` |
| Context/location interceptor (Extension) | ientc `lib/core/services/api/interceptors/api_location_interceptor.dart` |
| Interceptor-free upload (Extension) | ientc `lib/core/services/aws/s3_service.dart` |

Paired skill: `new-repository`.
