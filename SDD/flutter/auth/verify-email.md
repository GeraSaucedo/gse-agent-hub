# SDD — Email Verification

| | |
|---|---|
| **Feature** | Post-registration email verification |
| **Status** | `Reference (GSE base)` |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

---

## 1. Purpose & Scope

Confirm the user controls the email used at registration before granting an authenticated session.

| In scope | Out of scope |
|---|---|
| Verification code/link entry | Registration (`auth/register.md`) |
| Resend + expiry handling | Login (`auth/login.md`) |
| Transition to authenticated/login | Password recovery (`auth/password-recovery.md`) |

---

## 2. Constraints (architectural)

- A screen-scoped bloc with a **status enum**; submit is **droppable**.
- Repository returns **`Result<void, AuthFailure>`**.
- Verification is a **public route** (reachable pre-authentication; see `core/navigation.md`).
- Codes are single-use + time-limited (server-enforced); resend is rate-limited (server-side).

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `bloc_concurrency: ^0.3.0`, `formz: ^0.8.0`,
`freezed_annotation: ^3.0.0`.

> 🔎 Whether verification arrives as an emailed **link** (deep link) or an in-app **code** changes
> the entry point — state which; keep bloc internals out.

---

## 3. Observable States

```
awaiting ─(enter code / open link)─► verifying ─Success─► verified ─► (authenticated | go to login)
   │                                     └─Failure(expired/invalid)─► failure ─► awaiting
   └─(resend)─► sending ─► awaiting (new code)
```

---

## 4. Behavioral Flow

1. Arriving from registration, the user receives a code (or link).
2. Enter code / open link → `verifying` → `repository.verifyEmail()` → `Result`.
3. `Success` → account verified → session `authenticated` (or route to login, per app).
4. `Failure` (expired/invalid) → message + offer resend.
5. Resend → new code requested (rate-limited).

---

## 5. Interface

- `POST {provider}/auth/verify-email` — body `{ email|token, code? }` → success/failure.
- `POST {provider}/auth/resend-verification` — body `{ email }` → neutral acknowledgement.

> **Adapt for your app:** choose link vs. code delivery; set endpoints, code length, expiry.

---

## 6. Data Design

Holds no long-lived sensitive data. A verification code/token is transient and never persisted to
secure storage. On success, a session may be granted per `auth/overview.md` §4.

---

## 7. Security Considerations

- Codes/links single-use + time-limited (server-enforced).
- Rate-limit resend (server-side) to deter abuse.
- Neutral responses to avoid revealing account state where relevant.

---

## 8. Error Handling

| Condition | Behavior |
|---|---|
| Invalid/expired code or link | `failure` with "code expired, resend" |
| Malformed code (client) | field validation error; no request |
| Resend too frequent | server rate-limit message |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 apply if a session is granted here.)*

- **A1.** Valid code/link → `Success` → account verified; app follows the chosen transition (authenticated or login).
- **A2.** Expired/invalid code → `failure`, no verification, resend offered.
- **A3.** A verification code/token is never persisted to secure storage.
- **A4.** A second submit while `verifying` is dropped.

---

## 10. Risks & Open Questions

- **Open:** link (deep link) vs. code delivery — drives whether a verify deep-link route is needed.
- **R1.** Without server-side rate limiting, resend is an abuse vector.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Verify-email bloc | `base_app/lib/presentation/blocs/verify_email/` |
| Verify-email screen | `base_app/lib/presentation/screens/` (VerifyEmailScreen) |
| Verification call | `base_app/lib/data/repositories/auth/auth_repository.dart` |

Paired skill: `new-bloc`.
