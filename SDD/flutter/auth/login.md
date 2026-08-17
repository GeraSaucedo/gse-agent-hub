# SDD — Login (email / password)

| | |
|---|---|
| **Feature** | Native credential login |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

---

## 1. Purpose & Scope

Authenticate a user with email + password, persist tokens, and let the session status propagate.
Refresh, logout, register are separate docs.

| In scope | Out of scope |
|---|---|
| Credential entry, validation, submit | Session restore / refresh (`auth/refresh-token.md`) |
| Token persistence on success | Logout (`auth/logout.md`) |
| Login error feedback | Federated login (`auth/social-login.md`) |

---

## 2. Constraints (architectural)

- Form state via a screen-scoped bloc; inputs validated with **Formz**; progress via a **status enum**.
- The submit event uses a **droppable** transformer (no duplicate in-flight submits).
- The repository method returns **`Result<void, AuthFailure>`**; the bloc `switch`es on it (no try/catch).
- On success, tokens are persisted (secure) and the session status transitions to `authenticated`.

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `bloc_concurrency: ^0.3.0`, `formz: ^0.8.0`,
`email_validator: ^3.0.0`, `freezed_annotation: ^3.0.0`.

**Existing-app variant:** ientc used boolean flags + try/catch; same contract.

> 🔎 Status enum + `Result` switch is the GSE contract. The bloc's event names are out of scope.

---

## 3. Observable States

| Status | Meaning | UI |
|---|---|---|
| `initial` | entering credentials | form enabled |
| `invalid` | field fails validation (after first submit) | inline errors, submit disabled |
| `submitting` | request in flight | loading, inputs locked |
| `failure` | rejected / error | message, returns to editable |
| `success` | tokens obtained | session → authenticated → navigates away |

```
initial ─(valid+submit)─► submitting ─Success─► success
   ▲                          └─Failure(AuthFailure)─► failure ─► initial
   └─(invalid, post-submit)─► invalid ─► initial
```

---

## 4. Behavioral Flow

1. User enters email/password; validation surfaces after first submit.
2. Valid submit → `submitting` → `repository.loginWithEmailAndPassword()` → `Result`.
3. `Success` → tokens persisted (secure) → status `authenticated` (propagated via `authStatusStream`).
4. `Failure(AuthFailure)` → `failure` with mapped copy (`unauthorized` → "invalid credentials"; `network`/`timeout`/… → matching message).

---

## 5. Interface

`POST {provider}/auth/login` — body `{ email, password }` → tokens (`access`, `refresh`, + `userSub`).

> **Adapt for your app:** set the endpoint, request field names, and any tenant segment.

---

## 6. Data Design

Produces access/refresh tokens + `userSub` per `auth/overview.md` §4. Full profile may load post-auth.

---

## 7. Security Considerations

- Password never logged or persisted; masked in UI.
- Server remains the auth authority; client validation is UX only.
- Tokens written only to secure storage.

---

## 8. Error Handling

| `AuthFailure` | Behavior |
|---|---|
| `unauthorized` | specific "invalid credentials"; retry allowed |
| `network` / `timeout` | connectivity message; re-triggerable |
| `server` / `unknown` | generic failure; form re-editable |
| `invalidForm` | field-level validation errors |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 also apply.)*

- **A1.** Valid credentials → `Success` → tokens persisted in secure storage, status → `authenticated`.
- **A2.** `Failure(unauthorized)` → status stays `unauthenticated`, specific error shown, **no** tokens written.
- **A3.** Empty email or password → submit blocked, no network call.
- **A4.** Malformed email → `invalid`, submit blocked.
- **A5.** A second submit while `submitting` is dropped (no duplicate request).

---

## 10. Risks & Open Questions

- **R1.** Password policy at login should stay lenient (non-empty) so legacy passwords aren't blocked; strict rules belong in `auth/register.md`.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Login form bloc | `base_app/lib/presentation/blocs/login/` |
| Login + token persist | `base_app/lib/data/repositories/auth/auth_repository.dart` (`loginWithEmailAndPassword`) |
| Form inputs | `base_app/lib/data/inputs/` |

Paired skill: `new-bloc`.
