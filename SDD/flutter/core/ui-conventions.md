# SDD — UI Conventions (Design System & Localization)

| | |
|---|---|
| **Feature** | Mandatory design-system tokens + localization for all screens |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `new-screen` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Define the non-negotiable presentation conventions every GSE screen must follow: styling comes
from the design system (no ad-hoc values), and all user-facing text comes from localization.

| In scope | Out of scope |
|---|---|
| Design tokens (spacing, type, color) | Specific screen layouts (feature docs) |
| Responsive sizing helpers | Business copy content |
| Localization mandate + fallback | Right-to-left specifics (per app) |
| Screen file convention | Bloc internals (`new-bloc`) |

### 1.1 Terminology
- **Design token** — a named style value (spacing/color/text) exposed via context extensions.
- **Localization key** — an identifier resolved to translated text at runtime.

---

## 2. Constraints (architectural)

- Styling comes **only** from the design system package (`gse_design_system`): spacing, text
  styles, colors, and responsive sizing via context extensions. **No hard-coded** sizes/colors/text styles.
- All user-facing strings come from **localization** (`gse_localization` / `AppLocalizations`);
  **no string literals** in widgets.
- Screens follow the file convention: `<name>_screen.dart` + `<name>_view.dart`
  (+ `<name>_bloc_listener.dart` when a bloc drives navigation/overlays).

**Dependencies (pub):** `gse_design_system` (path package), `gse_localization` (path package),
`intl: ^0.20.2`, `flutter_localizations` (SDK).

**Existing-app variant:** an app without the GSE packages must still centralize tokens (a theme +
constants) and route strings through a localization layer — same contract, different packages.

> 🔎 "Use design tokens" and "localize all strings" are spec (GSE mandates them via `new-screen`).
> The concrete token names are the design-system package's API, not enumerated here.

---

## 3. Observable Behavior

| Concern | Contract |
|---|---|
| Spacing | from `context.spacing.<token>` (xs…xxl) |
| Text | from `context.textStyles.<token>` |
| Color | from `context.colors.<token>` |
| Size | responsive via `context.h()/w()/sp()` |
| Copy | from `AppLocalizations.of(context)` |

A screen renders identically to the design system's intent across supported device sizes and in
every supported locale.

---

## 4. Behavioral Flow

1. A screen imports the design system + localization.
2. Every visual value resolves from a token; every string from a localization key.
3. Locale changes re-resolve strings without a rebuild of business logic.

---

## 5. Interface

Design-system context extensions (`spacing`, `textStyles`, `colors`, sizing helpers) and
`AppLocalizations` lookups. Exact token names live in the `gse_design_system` package.

> **Adapt for your app:** point at your design-system + localization packages and their locales.

---

## 6. Data Design

Localization resources (ARB/generated) per supported locale; design tokens defined once in the
design-system package. No per-screen style constants.

---

## 7. Security Considerations

Not security-sensitive. Avoid embedding sensitive data in localized strings or logs.

---

## 8. Error Handling

- A missing localization key falls back to a defined default locale (never shows a raw key in production).
- A missing token is a build/lint failure, not a silent default.

---

## 9. Acceptance Criteria & Invariants

- **A1.** No widget contains a hard-coded color, text style, or spacing literal — all come from tokens.
- **A2.** No widget contains a user-facing string literal — all come from localization.
- **A3.** Switching locale updates all visible copy without restarting the app.
- **A4.** Screens follow the `<name>_screen` / `<name>_view` (+ listener) file convention.

**Invariants**
- **I1.** Presentation values have a single source (design system); there is no parallel style constant set.
- **I2.** User-facing text has a single source (localization).

---

## 10. Risks & Open Questions

- **R1.** Untranslated keys degrade UX silently — enforce a lint/CI check for missing keys.
- **R2.** Token drift if teams add ad-hoc styles — enforce via review + analyzer rules.

---

## 11. Traceability / Pairs-with

| Concern | File / package (GSE base_app) |
|---|---|
| Design system | `base_app/packages/design_system` (`gse_design_system`) |
| Localization | `base_app/packages/gse_localization` (`gse_localization`) |
| Screen convention | `base_app/lib/presentation/screens/**` (`*_screen.dart` + `*_view.dart`) |

Paired skill: `new-screen`.
