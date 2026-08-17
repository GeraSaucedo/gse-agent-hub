# SDD — Token Refresh & Session Restore

| | |
|---|---|
| **Feature** | Interceptor-driven mid-session refresh + startup session restore |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-repository` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

---

## 1. Purpose & Scope

Keep the access token valid: transparently on mid-session `401` (interceptor), and at cold start
(session restore / auto-login).

| In scope | Out of scope |
|---|---|
| Startup validity check + refresh | Obtaining first tokens (`auth/login.md`, social) |
| Mid-session refresh + request replay | Route redirect (`core/navigation.md`) |
| Force-logout on refresh failure | Logout intent flow (`auth/logout.md`) |

---

## 2. Constraints (architectural)

- Expiry is judged **client-side** from the JWT `exp` claim.
- **Mid-session refresh is handled by the refresh interceptor** (`core/api-client.md`): on `401` it
  refreshes, **replays** the original request, **single-flights** concurrent calls, and on failure
  triggers **force-logout**. Auth endpoints are whitelisted (never self-refreshed).
- **Startup restore** runs in the auth repository (`isUserLogged` → verify → refresh if expired).
- A refresh carries the refresh token; the new access token (and rotated refresh token, if any) is persisted.

**Dependencies (pub):** `dart_jsonwebtoken: ^2.8.0` (decode `exp`), `dio: ^5.9.1` (via `ApiClient`).

**Existing-app variant:** ientc refreshed **only** at session check (no interceptor), so a
mid-session `401` surfaced as an error until the next cold start. GSE resolves this — the
interceptor is the recommended target for existing apps too.

> 🔎 GSE closes the gap ientc had: refresh is transparent mid-session. Keep the whitelist and the
> single-flight queue — they are contract, not incidental.

---

## 3. Observable States

**Startup restore:**
```
cold start ─► unknown ─► [tokens present?]
     ├─ no ──────────────────────────► unauthenticated
     └─ yes ─► [access valid?]
                 ├─ yes ──────────────► authenticated
                 └─ no ─► [refresh ok?] ├─ yes ─► authenticated (new token saved)
                                        └─ no ──► unauthenticated
```

**Mid-session (interceptor):**
```
API call ─► 401 ─► refresh ─► ok ─► replay original request ─► success
                        └─ fail ─► force-logout ─► unauthenticated
concurrent 401s during refresh ─► queued ─► replayed after new token (single-flight)
```

---

## 4. Behavioral Flow

1. **Startup:** session check runs from splash → missing tokens → `unauthenticated`; valid access →
   `authenticated`; expired access + good refresh → refresh, persist, `authenticated`; refresh fails → `unauthenticated`.
2. **Mid-session:** any authorized call returning `401` is intercepted → single-flight refresh →
   original (and queued) requests replayed → on refresh failure, force-logout.

---

## 5. Interface

`POST {provider}/auth/refresh-token` — body `{ refresh_token }` → `{ access_token, refresh_token? }`.

> **Adapt for your app:** set the endpoint/param names; if the provider rotates refresh tokens,
> persist the returned refresh token (R4).

---

## 6. Data Design

Reads access/refresh tokens; writes the new access token (and rotated refresh token if returned).
Token model in `auth/overview.md` §4.

---

## 7. Security Considerations

- Refresh token never leaves secure storage except as the refresh request body.
- Client-side expiry cannot detect server revocation until a call fails (R3 in overview); the interceptor narrows the exposure window.
- Cap replay retries to avoid loops if the refreshed token is also rejected.

---

## 8. Error Handling

| Condition | Behavior |
|---|---|
| Missing token(s) at startup | `unauthenticated` |
| Startup refresh fails | `unauthenticated`; user re-authenticates |
| Mid-session `401` | interceptor refreshes + replays transparently |
| Mid-session refresh fails | **force-logout** → `unauthenticated` |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 also apply.)*

- **A1.** Valid, non-expired access token at startup → `authenticated` with **no** network call.
- **A2.** Expired access token + valid refresh (startup) → new access token persisted → `authenticated`.
- **A3.** Missing access **or** refresh token → `unauthenticated`.
- **A4.** Mid-session `401` → token refreshed and the original request replayed once, transparently to the caller.
- **A5.** Concurrent `401`s during a refresh → refresh runs once; all are replayed after (single-flight).
- **A6.** Mid-session refresh failure → force-logout (`unauthenticated`); auth endpoints are never refreshed.

---

## 10. Risks & Open Questions

- **R4.** Refresh-token rotation: persist the returned refresh token, else the next refresh fails.
- **R5.** Replay must be retry-capped to prevent infinite refresh↔401 loops.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Refresh interceptor (401 queue + replay + onRefreshFailed) | `base_app/lib/core/services/api/interceptors/refresh_token_interceptor.dart` |
| Startup restore + verify | `base_app/lib/data/repositories/auth/auth_repository.dart` (`isUserLogged`, `_verifyTokenValidation`) |
| JWT expiry | `base_app/lib/data/repositories/auth/jwt_utils.dart` |

Paired skill: `new-repository`.
