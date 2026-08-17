# SDD — Logout

| | |
|---|---|
| **Feature** | Session termination + credential clearing (user-initiated & forced) |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

---

## 1. Purpose & Scope

End the session — whether the user requests it or a failed refresh forces it — clearing all local
credentials and returning the app to `unauthenticated`.

| In scope | Out of scope |
|---|---|
| User-initiated logout | Token refresh (`auth/refresh-token.md`) |
| Forced logout (refresh failure) | Route redirect (`core/navigation.md`) |
| Clearing tokens + user | — |

---

## 2. Constraints (architectural)

- Logout is driven via the **`AuthCubit`** → auth repository, returning `Result<void, AuthFailure>`.
- **Forced logout** is triggered by the refresh interceptor's `onRefreshFailed` callback when a
  mid-session refresh fails (`core/api-client.md`, `auth/refresh-token.md`).
- Local clearing is **unconditional**: even if the provider logout call fails, credentials are cleared.
- On completion the repository emits `unauthenticated` on `authStatusStream`.

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `flutter_secure_storage: ^10.0.0`.

**Existing-app variant:** ientc drove logout via `AuthBloc` and had no forced-logout path (no
refresh interceptor); the local-clear-unconditionally contract is the same.

> 🔎 "Clear locally regardless of network outcome" (soft logout, R2) and "forced logout on refresh
> failure" are both contract — restate them so neither is dropped.

---

## 3. Observable States

```
authenticated ─(user logout | refresh-failed force-logout)─► (clearing) ─► unauthenticated ─► redirect to login
```

---

## 4. Behavioral Flow

1. Trigger: user action **or** `onRefreshFailed` from the interceptor.
2. Auth repository `POST /auth/logout` (best-effort).
3. Regardless of the response, clear all tokens (+ `userSub`) and cached user.
4. Emit `unauthenticated` on `authStatusStream`; the guard redirects to login.

---

## 5. Interface

`POST {provider}/auth/logout` — invalidates the session server-side (best-effort).

> **Adapt for your app:** set the endpoint and which token the provider expects to invalidate.

---

## 6. Data Design

Removes every session value in `auth/overview.md` §4 (access/refresh tokens, `userSub`, cached user;
+ `id_token`/`federated` for social sessions).

---

## 7. Security Considerations

- After logout no token key is readable from secure storage (I3).
- Soft logout (R2): a failed provider call may leave the server token valid — mitigated by short
  access-token TTL and the refresh interceptor's force-logout; consider retry if strict invalidation is required.

---

## 8. Error Handling

| Condition | Behavior |
|---|---|
| Provider logout fails (network/5xx) | logged; **not** a blocking error; local clear proceeds |
| Forced logout (refresh failed) | same clearing path; user sent to login |
| Already logged out | idempotent no-op |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 apply; I3 is central here.)*

- **A1.** Logout clears all tokens, `userSub`, and cached user; status → `unauthenticated`.
- **A2.** Logout with a failing provider call **still** clears local credentials (A1 holds).
- **A3.** A mid-session refresh failure force-logs-out via the interceptor (same end state as A1).
- **A4.** After logout, navigating to a protected route redirects to login.
- **A5.** Logout is idempotent with no session.

---

## 10. Risks & Open Questions

- **R2.** Soft logout: provider-side token may survive a failed logout call. Acceptable given short
  TTL + force-logout, or add bounded retry?

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Logout action + clearing + stream | `base_app/lib/data/repositories/auth/auth_repository.dart` (`logout`) |
| Session cubit | `base_app/lib/presentation/blocs/auth/auth_cubit.dart` |
| Forced-logout trigger | `base_app/lib/core/services/api/interceptors/refresh_token_interceptor.dart` (`onRefreshFailed`) |
| Token clearing | `base_app/lib/core/services/storage/utils/token_manager.dart` |

Paired skill: `new-bloc`.
