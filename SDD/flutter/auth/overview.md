# SDD — Authentication Overview (session model & shared invariants)

| | |
|---|---|
| **Feature** | Cross-flow session model, token contract, invariants shared by all auth docs |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc`, `new-repository` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Authentication is one system split into flow docs (login, refresh, logout, register, verify-email,
password-recovery, social). This doc owns what they **share**: the session state machine, the token
model, and the invariants (I1–I5). Flow docs reference this file instead of duplicating it.

| In scope | Out of scope |
|---|---|
| Session status state machine | Per-flow steps (each flow's doc) |
| Token model + storage placement | UI/form details (`auth/login.md`) |
| Session propagation (`authStatusStream`) | Route redirect mechanics (`core/navigation.md`) |
| Shared invariants I1–I5 | Backend implementation |

### 1.1 Terminology
- **Access / refresh token** — see §4. **`userSub`** — the subject/user id persisted with tokens.
- **Session status** — `unknown | authenticated | unauthenticated`.
- **Federated** — session via an external identity provider (Extension: `auth/social-login.md`).

---

## 2. Constraints (architectural)

- The **auth repository** owns session state: it exposes an **`authStatusStream`** (broadcast) plus
  a synchronous **`currentStatus`** for the router guard, and `isUserLogged()` for startup.
- A thin **`AuthCubit`** wraps repository actions (`checkAuthStatus`, `logout`) for the UI; flow
  blocs (login/register/…) handle their own forms.
- Session-establishing actions return **`Result<void, AuthFailure>`** (see `core/error-handling.md`).
- Tokens live in **secure storage** via a token manager; token expiry judged client-side (JWT `exp`).
- Mid-session refresh is handled by the **refresh interceptor** (`core/api-client.md`), not per feature.
- **Mock auth** is supported for testing via an env flag (e.g. `EnvConfig.useMockAuth`).

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `freezed_annotation: ^3.0.0`, `get_it: ^9.2.0`,
`flutter_secure_storage: ^10.0.0`, `dart_jsonwebtoken: ^2.8.0`.

**Existing-app variant:** ientc used an `AuthBloc` holding status (no broadcast stream) and
try/catch instead of `Result` — same session contract, older mechanics.

> 🔎 The repository-owned session stream + thin cubit split is spec. The events/handlers of any
> flow bloc are not — never enumerate them.

---

## 3. Observable States (session)

The session is always in exactly one status, propagated on `authStatusStream`:

| Status | Meaning | Router effect (`core/navigation.md`) |
|---|---|---|
| `unknown` | startup; session not yet resolved | hold on splash |
| `authenticated` | valid/refreshable session | allow protected routes |
| `unauthenticated` | no/invalid session | force to login |

```
unknown ──(check ok)──► authenticated ──(logout / refresh fails → force-logout)──► unauthenticated
   └──(no/invalid tokens)──► unauthenticated ──(login / register+verify / social ok)──► authenticated
```

> 🔎 `unknown` is required, not incidental — it prevents a login↔home flash before the check resolves.

---

## 4. Token Model & Data Design

| Token / value | Storage | Sensitivity | Purpose |
|---|---|---|---|
| Access token (JWT) | secure | high | `Authorization: Bearer` on API calls |
| Refresh token | secure | high | obtain a new access token |
| `userSub` | secure | high | subject/user id tied to the session |
| Cached user | local | low | fast identity restore on startup |

**Extension (social):** federated sessions add an `id_token` + a `federated` flag (see `auth/social-login.md`).

- Tokens are stored as individual values (no aggregate token model required).
- The cached user is only meaningful while valid/refreshable tokens exist (I4).

---

## 5. Interface (shared contract)

Backend-agnostic auth provider surface consumed by the flow docs:

| Endpoint (abstract) | Method | Used by |
|---|---|---|
| `/auth/login` | POST | `auth/login.md` |
| `/auth/refresh-token` | POST | `auth/refresh-token.md` |
| `/auth/logout` | POST | `auth/logout.md` |
| `/auth/register` | POST | `auth/register.md` |
| `/auth/verify-email` | POST | `auth/verify-email.md` |
| `/auth/forgot-password`, `/auth/reset-password` | POST | `auth/password-recovery.md` |
| provider OAuth (Extension) | GET | `auth/social-login.md` |

> **Adapt for your app:** replace paths with your provider's real endpoints; contracts and invariants stay.

---

## 6. Security Considerations

- Only secure storage holds tokens; the bearer interceptor reads them at send time (`core/api-client.md`).
- Logout removes all secure keys for the session (I3).
- Client-side expiry cannot detect server revocation until a call fails (R3) — mitigated by the refresh interceptor.

---

## 7. Error Handling

Auth actions return `Result<void, AuthFailure>`; the UI maps the `AuthFailure` to copy. Mid-session
`401` is handled by the refresh interceptor (refresh + replay, else force-logout) — see `auth/refresh-token.md`.

---

## 8. Acceptance Criteria & Invariants (SHARED — referenced by all auth docs)

**Invariants (must always hold across every auth flow):**
- **I1.** A request carrying `Authorization: Bearer` implies a token existed in secure storage at send time.
- **I2.** `status == authenticated` ⇒ a resolvable user/`userSub` is present.
- **I3.** After logout, no token key remains readable from secure storage.
- **I4.** A cached user without valid/refreshable tokens never yields `authenticated`.
- **I5.** Session-establishing actions return `Result`; they never leak a raw exception to the bloc/UI.

Each flow doc adds its own `A#` criteria and links here rather than restating I1–I5.

---

## 9. Risks & Open Questions

- **R3.** Client-side expiry only: clock skew / server revocation undetected until a call fails (the refresh interceptor narrows the window).
- **R4.** Refresh-token rotation: if the provider rotates the refresh token, persist the returned one (see `auth/refresh-token.md`).

---

## 10. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Auth repository (status stream + isUserLogged) | `base_app/lib/data/repositories/auth/auth_repository.dart` |
| Failure enum | `base_app/lib/data/repositories/auth/auth_failures.dart` |
| JWT expiry | `base_app/lib/data/repositories/auth/jwt_utils.dart` |
| Session cubit | `base_app/lib/presentation/blocs/auth/auth_cubit.dart` |
| Token manager | `base_app/lib/core/services/storage/utils/token_manager.dart` |

Paired skills: `new-bloc`, `new-repository`.
