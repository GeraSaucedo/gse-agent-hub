# GSE Flutter — SDD Kit

Reusable **Software Design Documents** for Flutter apps. They are the ***what*** — feature
contracts and acceptance criteria — paired with the Hub's ***how*** (the Flutter skills:
`new-bloc`, `new-model`, `new-repository`, `new-screen`, `architecture`).

```
SDD (what)  ──►  Skill (how)  ──►  code  ──►  verify against the SDD's Acceptance Criteria
 contract        convention
 criteria        scaffold
```

## Baseline: the GSE base_app

New apps are **born from the GSE base_app** (`.agents/skills/flutter/architecture/base_app/`),
so that is the **canonical baseline** these docs describe. Where the mature reference app
`flutter_ientc_empleados` has a superior or additional pattern the base lacks, it is folded in as
a marked **Extension**. This is the "best conventions of each" merge:

| Concern | Baseline (GSE base_app) | Merged from ientc |
|---|---|---|
| Immutability | **Freezed** (state + models), status enums, bloc transformers | manual JSON/Equatable = existing-app migration variant |
| Errors | **`Result<S,E>`** at repo + `ApiException` at API + `mapDioToFailure` | — |
| Token refresh | **`RefreshTokenInterceptor`** (401 queue + force-logout) | — |
| Routing | go_router + **`authStatusStream`** refreshListenable guard | — |
| Auth flows | login, register, verify-email, forgot-password (3 steps) | **social/OAuth login** (Extension) |
| UI | **design system + localization mandatory** | — |
| Interceptors | bearer, refresh, logger | **context/location interceptor** (Extension) |

## How to use this kit in a new app

1. Scaffold from the GSE base (skill `architecture`).
2. Copy the relevant docs into the app's `docs/SDD/`.
3. Fill each doc's **"Adapt for your app"** items (endpoints, provider, copy).
4. Generate structure with the paired skill; derive tests from Section 9 (one test per criterion).

**Existing (non-GSE) apps:** use the **existing-app variant** notes (Equatable/manual JSON,
try/catch-in-bloc) as the migration target — same contracts, older mechanics.

New docs start from [`_TEMPLATE.md`](./_TEMPLATE.md).

## When to write an SDD (trigger rules)

Depth is proportional to cost-of-error, not a fixed ritual.

- **Always** — consistency/concurrency/security-heavy features: auth, refresh, payments, booking
  availability, offline sync, cash/shift close.
- **Usually** — cross-cutting infrastructure reused across screens (`core/`, `crosscutting/`).
- **Thin or none** — trivial CRUD/settings the code documents by itself.

Do **not** retro-document stable, simple code — an unmaintained SDD is a liability.

## Status legend

- **G — `Reference (GSE base)`**: grounded in `base_app`; Traceability cites base_app files.
- **X — `Extension (ientc)`**: grounded in `flutter_ientc_empleados`, optional, beyond the GSE base.
- **P — `Proposed (greenfield)`**: standard/expected, not yet built anywhere; no Traceability.

## Index

### Core — foundational contracts every GSE app inherits
| Doc | Status | Pairs with |
|---|---|---|
| [`core/architecture.md`](./core/architecture.md) — layers, Freezed, status enums, transformers | G | `architecture` |
| [`core/api-client.md`](./core/api-client.md) — client facade + interceptor chain | G | `new-repository` |
| [`core/error-handling.md`](./core/error-handling.md) — `Result<S,E>` + `ApiException` | G | `new-repository`, `new-bloc` |
| [`core/storage.md`](./core/storage.md) — secure/local storage + managers | G | `architecture` |
| [`core/dependency-injection.md`](./core/dependency-injection.md) — 3-phase get_it | G | `new-module` |
| [`core/navigation.md`](./core/navigation.md) — go_router + stream-driven guard | G | `new-screen` |
| [`core/ui-conventions.md`](./core/ui-conventions.md) — design system tokens + localization | G | `new-screen` |

### Auth — Tier 1 family (unified by `overview.md`)
| Doc | Status | Pairs with |
|---|---|---|
| [`auth/overview.md`](./auth/overview.md) — session model + shared invariants | G | — |
| [`auth/login.md`](./auth/login.md) — email/password login | G | `new-bloc` |
| [`auth/refresh-token.md`](./auth/refresh-token.md) — interceptor refresh + session restore | G | `new-repository` |
| [`auth/logout.md`](./auth/logout.md) — logout + credential clearing | G | `new-bloc` |
| [`auth/register.md`](./auth/register.md) — sign-up | G | `new-bloc` |
| [`auth/verify-email.md`](./auth/verify-email.md) — post-register verification | G | `new-bloc` |
| [`auth/password-recovery.md`](./auth/password-recovery.md) — forgot-password (3 steps) | G | `new-bloc` |
| [`auth/social-login.md`](./auth/social-login.md) — federated/OAuth | X | `new-bloc` |

## GSE base stack (default packages)

Names + versions from `base_app/pubspec.yaml` (Dart SDK per template). A new app inherits these.

| Concern | Packages |
|---|---|
| State management | `flutter_bloc: ^9.1.1`, `bloc: ^9.2.0`, `bloc_concurrency: ^0.3.0` |
| Immutability / models | `freezed_annotation: ^3.0.0` + dev `freezed: ^3.0.0`, `build_runner: ^2.4.0` |
| Dependency injection | `get_it: ^9.2.0` |
| Routing | `go_router: ^17.1.0` |
| HTTP client | `dio: ^5.9.1` |
| Secure storage | `flutter_secure_storage: ^10.0.0` |
| Local storage | `shared_preferences: ^2.5.4` |
| Forms / validation | `formz: ^0.8.0`, `email_validator: ^3.0.0` |
| JWT decode | `dart_jsonwebtoken: ^2.8.0` |
| Design system / i18n | `gse_design_system` (path), `gse_localization` (path), `intl: ^0.20.2` |
| Misc | `animate_do: ^4.2.0`, `flutter_svg: ^2.2.3`, `package_info_plus: ^9.0.0` |
| Lints | dev `very_good_analysis: 10.1.0`, `flutter_lints: ^6.0.0` |
| Testing | add per project: `bloc_test`, `mocktail` (documented by the `testing` skill; not in base pubspec) |

> The base uses a custom `AppLogger` (no `logger` package) and **Freezed instead of Equatable**.

## Extension packages (add only for the marked feature)

Beyond the GSE base; grounded in ientc. Pull the row in only when adopting that feature.

| Feature | Packages |
|---|---|
| Social / OAuth login (`X`) | `flutter_web_auth_2`, `url_launcher`, `app_links` |
| Deep linking (Tier 2) | `app_links` |
| Push notifications (Tier 2) | `firebase_core`, `firebase_messaging`, `flutter_local_notifications` |
| Pagination/infinite list (Tier 2) | `infinite_scroll_pagination`, `stream_transform` |
| File/media upload (Tier 2) | `image_picker`, `file_picker`, `flutter_image_compress` |
| In-app update (Tier 2) | `app_version_update`, `url_launcher` |
| Offline / local SQL (Tier 2) | `sqflite` |
| Persisted bloc state | `hydrated_bloc` |

## Deferred (later passes)

Cross-cutting (Tier 2): push-notifications, deep-linking, in-app-update, file/media-upload,
pagination/infinite-list, permissions. Greenfield: offline-sync/outbox, feature-flags, search,
settings/profile, biometric/MFA.

## Conventions

English, kebab-case filenames, format per [`_TEMPLATE.md`](./_TEMPLATE.md). Baselines: GSE
`base_app`; Extensions: `flutter_ientc_empleados`.
