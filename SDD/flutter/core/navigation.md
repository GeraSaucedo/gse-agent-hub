# SDD — Navigation & Route Protection

| | |
|---|---|
| **Feature** | Declarative routing, stream-driven auth guard, deep-link entry |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `new-screen` (adds routes/screens) |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Define how the app routes between screens, how it prevents unauthenticated access, and how the
router reacts to session changes.

| In scope | Out of scope |
|---|---|
| Route table + nesting | Screen internals (`new-screen`, `core/ui-conventions.md`) |
| Stream-driven auth guard | Auth logic itself (`auth/*`) |
| Public-route allow-list | Push payload handling (deferred) |

### 1.1 Terminology
- **Guard/redirect** — a pre-navigation hook that can rewrite the destination.
- **`authStatusStream`** — the auth repository's broadcast stream the router listens to.

---

## 2. Constraints (architectural)

- Routing uses **go_router**, declared once, with a global `redirect` guard.
- The router's `refreshListenable` is driven by the auth repository's **`authStatusStream`**, so a
  session change re-runs the guard automatically.
- The guard's decision derives from the auth repository's **current status** (fast, non-awaiting),
  not from a direct storage read.
- A **public-route allow-list** (login, splash, register, verify-email, forgot-password steps,
  onboarding) is exempt from protection.

**Dependencies (pub):** `go_router: ^17.1.0`. (Deep-link intake is an Extension — see §3.)

> 🔎 "Guard reads auth status from the stream/repository" is contract. Whether it uses
> `refreshListenable` vs. a listener is implementation — do not pin it here.

---

## 3. Observable States (routing outcomes)

The guard resolves every navigation against session status:

| Session status | On a protected route | On a public route |
|---|---|---|
| `authenticated` | allow | redirect → home |
| `unauthenticated` | redirect → login | allow |
| `unknown` (startup) | hold on splash | hold on splash |

```
launch ─► /splash ─► (session check) ─► authenticated ─► /home
                                    └─► unauthenticated ─► /login
session change (stream) ─► guard re-runs ─► redirect as above
```

**Extension (ientc):** external URIs (OAuth callbacks, universal links) received via `app_links`
are translated to `go(route + query)`; the guard still applies. Needed for `auth/social-login.md`.

> 🔎 `unknown` is a required design decision, not incidental — it prevents a login↔home flash
> before the session check resolves. Collapsing it to a boolean breaks startup.

---

## 4. Behavioral Flow

1. App starts at splash; the session check runs (see `auth/overview.md` / `auth/refresh-token.md`).
2. Until status is known, the guard holds the user on splash.
3. On resolution, the guard routes to home or login.
4. Any later session change emits on `authStatusStream` → guard re-runs (e.g. force-logout on refresh failure → login).

---

## 5. Interface

- Route table: `/splash`, `/login`, `/register`, `/verify-email`, forgot-password steps,
  `/onboarding` (all public) + `/` (home, protected) and nested feature routes.
- Guard: a global redirect `(context, state) → String?` returning an override path or null.
- `refreshListenable`: bound to `authStatusStream`.

> **Adapt for your app:** set your real routes and which are public; wire the guard to your auth
> repository's status stream.

---

## 6. Data Design

Routes carry parameters via path/query. An OAuth callback route (Extension) consumes query tokens
then hands them to the auth flow (`auth/social-login.md`); it does not persist them itself.

---

## 7. Security Considerations

- The guard is the single choke point for route protection — no screen self-guards ad hoc.
- Deep links (Extension) are untrusted input: validate/parse query params; the guard re-evaluates session status before privileged routes.

---

## 8. Error Handling

- Unknown routes resolve to a defined fallback (not a crash).
- A malformed deep link is ignored (logged), leaving current navigation intact.

---

## 9. Acceptance Criteria & Invariants

- **A1.** Navigating to a protected route while `unauthenticated` lands on login.
- **A2.** Navigating to a public route while `authenticated` lands on home.
- **A3.** While status is `unknown`, neither home nor login is shown (splash holds).
- **A4.** A session change emitted on `authStatusStream` re-runs the guard without a manual navigation.
- **A5.** *(Extension)* A malformed deep link does not change the current route.

**Invariants**
- **I1.** Every protected route passes through the guard; there is exactly one guard.
- **I2.** The guard's decision derives from auth status (stream/repository), never a direct storage read.

---

## 10. Risks & Open Questions

- **R1.** Deep links (Extension) can target authenticated routes before session resolves — ensure the guard re-runs after `unknown → authenticated`, or queue the link.
- **R2.** Universal/app-link platform config (iOS entitlements, Android intent filters) lives outside Dart; document per app.

---

## 11. Traceability / Pairs-with

| Concern | File |
|---|---|
| Router + routes + refreshListenable | `base_app/lib/core/routes/app_router.dart` |
| Auth guard + public routes | `base_app/lib/core/routes/app_auth_redirect.dart` |
| Status stream source | `base_app/lib/data/repositories/auth/auth_repository.dart` (`authStatusStream`) |
| Deep-link intake (Extension) | ientc `lib/main_app.dart` (app_links) |

Paired skill: `new-screen` (adds a screen + its route honoring the guard).
