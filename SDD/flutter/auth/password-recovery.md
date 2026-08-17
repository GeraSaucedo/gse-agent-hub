# SDD — Password Recovery (forgot password)

| | |
|---|---|
| **Feature** | Reset a forgotten password (3-step flow) |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

---

## 1. Purpose & Scope

Let a user regain access via a **three-step** flow — identify → verify code → set new password —
without exposing account existence.

| In scope | Out of scope |
|---|---|
| Username/email step | Login (`auth/login.md`) |
| Code verification step | Change-password while logged in (own doc) |
| Set-new-password step | Registration (`auth/register.md`) |

---

## 2. Constraints (architectural)

- Three sequential screens under one **shell route** (public routes): username → code → form.
- Each step is a screen-scoped bloc with a **status enum**; submits are **droppable**.
- New-password validation reuses the **strict** ruleset from `auth/register.md`.
- Repository steps return **`Result<void, AuthFailure>`**.
- Request-step responses are **neutral** — identical whether or not the account exists.
- On success, route to login (no implicit session) unless the app decides otherwise.

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `bloc_concurrency: ^0.3.0`, `formz: ^0.8.0`,
`email_validator: ^3.0.0`, `freezed_annotation: ^3.0.0`. (Emailed reset links would also need `app_links`.)

> 🔎 The three-step shell is the GSE shape. Keep the steps as distinct contracts; keep bloc internals out.

---

## 3. Observable States (per step)

```
username: initial ─(submit)─► submitting ─Success─► code-step (neutral confirmation)
                                   └─Failure─► failure ─► initial
code:     initial ─(submit)─► submitting ─Success─► form-step
                                   └─Failure(invalid/expired)─► failure
form:     initial ─(valid+submit)─► submitting ─Success─► go to login
                                   └─Failure(weak/expired)─► failure
```

---

## 4. Behavioral Flow

1. **Username:** user enters email/username → submit → provider sends a code. Neutral confirmation
   ("if an account exists, you'll receive a code") → advance to code step.
2. **Code:** user enters the code → verify → advance to form step.
3. **Form:** user enters new password (+ confirm) → submit → success → route to login.
4. Any invalid/expired code or weak password → step `failure` with appropriate copy.

---

## 5. Interface

- `POST {provider}/auth/forgot-password` — body `{ email }` → always neutral.
- `POST {provider}/auth/verify-reset-code` — body `{ email, code }` → success/failure.
- `POST {provider}/auth/reset-password` — body `{ email, code, new_password }` → success/failure.

> **Adapt for your app:** set endpoints; choose emailed link vs. in-app code; token/code lifetime + single-use (server-owned).

---

## 6. Data Design

Holds no long-lived sensitive data. Reset code/token is transient and never persisted to secure
storage. Default grants no session (routes to login).

---

## 7. Security Considerations

- **Anti-enumeration:** the username step must not reveal whether the email exists.
- Reset codes are single-use + time-limited (server-enforced); rate-limit the request step (server-side).
- New password enforced by strict rules client- and server-side; never logged.

---

## 8. Error Handling

| Condition | Behavior |
|---|---|
| Malformed email (username step) | field error; no request |
| Any username-step outcome | neutral confirmation (no existence signal) |
| Invalid/expired code | `failure` "code expired, request a new one" |
| Weak/mismatched new password | field-level validation error |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 apply only if the rare auto-login variant is chosen.)*

- **A1.** Username step returns the **same** neutral response for existing and non-existing emails.
- **A2.** Valid code advances to the form step; invalid/expired code → `failure`.
- **A3.** Strong new password + valid code → reset succeeds → routed to login.
- **A4.** New password failing strict rules or not matching confirm → submit blocked.
- **A5.** A reset code/token is never persisted to secure storage.

---

## 10. Risks & Open Questions

- **Open:** emailed link vs. in-app code — link needs a deep-link reset route (Extension).
- **R1.** Without server-side rate limiting, the request step is an abuse vector.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Forgot-password blocs | `base_app/lib/presentation/blocs/forgot_password/` |
| 3-step screens (shell route) | `base_app/lib/presentation/screens/` (ForgotPasswordUsername/Code/Form) |
| Reset calls | `base_app/lib/data/repositories/auth/auth_repository.dart` |
| Shell route | `base_app/lib/core/routes/app_router.dart` |

Paired skill: `new-bloc`.
