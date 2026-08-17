# SDD — Registration (sign-up)

| | |
|---|---|
| **Feature** | New-account creation |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

---

## 1. Purpose & Scope

Create a new account from user-provided details, then route into email verification (GSE default)
before an authenticated session is granted.

| In scope | Out of scope |
|---|---|
| Sign-up form + validation | Login (`auth/login.md`) |
| Account creation request | Email verification step (`auth/verify-email.md`) |
| Post-create routing | Password reset (`auth/password-recovery.md`) |

---

## 2. Constraints (architectural)

- Form via a screen-scoped bloc; inputs validated with **Formz**; progress via a **status enum**;
  submit is **droppable**.
- Password uses the **strict** ruleset (min length + character classes) + confirm-password match —
  unlike login's lenient submit.
- Repository returns **`Result<void, AuthFailure>`**; bloc `switch`es (no try/catch).
- GSE default: after create, route to **email verification** (`auth/verify-email.md`), not an immediate session.

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `bloc_concurrency: ^0.3.0`, `formz: ^0.8.0`,
`email_validator: ^3.0.0`, `freezed_annotation: ^3.0.0`.

> 🔎 Strict password rules belong here, not in `auth/login.md`. Keep them separated.

---

## 3. Observable States

```
initial ─(valid+submit)─► submitting ─Success─► success ─► go to verify-email
   ▲                          └─Failure(client/conflict/…)─► failure ─► initial
   └─(invalid, post-submit)─► invalid ─► initial
```

---

## 4. Behavioral Flow

1. User enters email, password, confirm, + app-specific profile fields.
2. Validation surfaces after first submit; confirm-password must match.
3. Valid submit → `submitting` → `repository.register()` → `Result`.
4. `Success` → route to `auth/verify-email.md` (GSE default).
5. `Failure` → mapped message (duplicate → field-level per enumeration policy; invalid → field).

---

## 5. Interface

`POST {provider}/auth/register` — body `{ email, password, …profile }` → created acknowledgement
(GSE: verification required before login).

> **Adapt for your app:**
> - Required profile fields + validation.
> - Post-create behavior: GSE default is **verify-email then login**; an app may instead auto-login
>   (then invariants I1–I5 apply immediately).

---

## 6. Data Design

GSE default persists nothing sensitive at this step (session granted after verification/login). If
an app auto-logs-in, produces the token set per `auth/overview.md` §4.

---

## 7. Security Considerations

- Enforce strict password rules client- **and** server-side.
- Anti-enumeration: prefer neutral messaging unless product explicitly wants "email already registered".
- Passwords never logged.

---

## 8. Error Handling

| `AuthFailure` | Behavior |
|---|---|
| `conflict`/`client` (email exists) | field-level "email in use" (per enumeration policy) |
| `invalidForm` | map to the offending field |
| `network`/`server`/`unknown` | generic failure; form re-editable |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 apply only if auto-login is chosen.)*

- **A1.** Valid new details → `Success` → app routes to verify-email (GSE default).
- **A2.** Password ≠ confirm → submit blocked, field error shown.
- **A3.** Weak password (fails strict rules) → `invalid`, submit blocked.
- **A4.** Duplicate account → `failure`, no session established.
- **A5.** A second submit while `submitting` is dropped.

---

## 10. Risks & Open Questions

- **Open:** verify-email-then-login (GSE default) vs. auto-login — decide per app.
- **R1.** Account-enumeration exposure via duplicate-email errors — align with product/security.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Register form bloc | `base_app/lib/presentation/blocs/register/` |
| Register screen | `base_app/lib/presentation/screens/register/` |
| Account creation | `base_app/lib/data/repositories/auth/auth_repository.dart` |

Paired skill: `new-bloc`.
