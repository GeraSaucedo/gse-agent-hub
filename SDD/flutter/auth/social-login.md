# SDD — Social / Federated Login (OAuth)

| | |
|---|---|
| **Feature** | Login via an external identity provider (OAuth/OIDC), e.g. Google |
| **Status** | `Extension (ientc)` — not in the GSE base; optional per app |
| **Layer** | Auth |
| **Pairs with skill** | `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |
| **Shared model** | [`auth/overview.md`](./overview.md) (session states, token model, invariants I1–I5) |

> ⚠️ **Extension.** The GSE `base_app` does **not** include social login. This contract is grounded
> in `flutter_ientc_empleados`; adopt it only when an app needs federated auth, and add the
> extension packages below.

---

## 1. Purpose & Scope

Authenticate through an external provider, receive tokens via a redirect/deep-link callback, and
establish the same session as native login — flagged `federated = true`.

| In scope | Out of scope |
|---|---|
| OAuth launch + callback intake | Native login (`auth/login.md`) |
| Token persistence, `federated=true` | Provider console/entitlement setup (platform config) |
| Platform launch differences | Refresh/logout (their docs; token choice differs by flag) |

---

## 2. Constraints (architectural)

- The provider hosts the auth UI in a browser; the app never handles the provider password.
- Callback delivery is platform-specific: an **in-app web auth session** (iOS) and an **external
  browser + deep link** (Android) — both converge on the same token intake.
- On success tokens (incl. `id_token`) are persisted and `federated = true`.
- Deep-link intake reuses the routing Extension in `core/navigation.md`.

**Dependencies (pub, Extension):** `flutter_web_auth_2` (in-app callback), `url_launcher` (external
browser), `app_links` (deep-link callback), `flutter_bloc: ^9.1.1`.

> 🔎 The per-platform launch mechanism is a constraint worth stating (it affects the callback
> route); the bloc's internal events are still out of scope.

---

## 3. Observable States

```
idle ─(provider login requested)─► launching ─► (provider UI) ─► callback received
        callback: all tokens present ─► success ─► session authenticated (federated)
        callback: missing/denied ─────► failure ─► idle
```

---

## 4. Behavioral Flow

1. User taps provider login → app builds the provider URL (+ redirect scheme where required).
2. Launch: iOS in-app web auth; Android external browser.
3. Provider authenticates and redirects to the app's callback URI carrying tokens (+ email).
4. Callback received (web-auth result on iOS; app_links deep link on Android/router query).
5. All tokens present → persist, `federated = true`, minimal user (email) → `success` → `authenticated`.
6. Missing tokens / user cancels → `failure`, no partial session.

---

## 5. Interface

`GET {provider}/oauth/login` (provider-specific) → redirect to callback URI
`{scheme}://…?access_token&refresh_token&id_token&email`.

> **Adapt for your app:** set the provider endpoint, redirect URL scheme, and platform config
> (iOS associated domains/URL types, Android intent filters) — these live outside Dart.

---

## 6. Data Design

Produces access/refresh tokens **plus** `id_token` and a `federated = true` flag — the federated
extension of the token model in `auth/overview.md` §4. Callback query params are consumed then discarded.

---

## 7. Security Considerations

- Use a unique, app-owned redirect scheme; validate the callback + required params before trust.
- Tokens arrive via URI query — persist to secure storage immediately; never log the callback URL.
- The app never sees provider credentials.

---

## 8. Error Handling

| Condition | Behavior |
|---|---|
| User cancels / denies | `failure` → idle, no error noise |
| Callback missing a required token | failure; no partial session |
| Deep link malformed | ignored (see `core/navigation.md` A5) |

---

## 9. Acceptance Criteria

*(Shared invariants I1–I5 in [`auth/overview.md`](./overview.md) §8 also apply; I5 is central here.)*

- **A1.** Callback with all tokens → tokens persisted, `federated = true`, session → `authenticated`.
- **A2.** Callback missing a required token → `failure`, **no** tokens persisted, no partial session.
- **A3.** User cancellation returns to idle without a blocking error.
- **A4.** A federated session's later refresh/logout uses the flag-appropriate token (those docs).

---

## 10. Risks & Open Questions

- **R1.** Platform callback config (entitlements/intent filters) lives outside Dart and is a common breakage source — track per app.
- **R2.** Multiple providers multiply callback handling; keep intake generic if more than one is planned.

---

## 11. Traceability / Pairs-with

| Concern | File (ientc — Extension source) |
|---|---|
| OAuth launch + callback | `lib/presentation/blocs/login/login_bloc.dart` (Google flow) |
| Deep-link intake | `lib/main_app.dart` (app_links), `lib/core/routes/app_router.dart` (query parse) |
| Token persistence | `lib/core/services/storage/utils/token_manager.dart` |

Paired skill: `new-bloc`.
