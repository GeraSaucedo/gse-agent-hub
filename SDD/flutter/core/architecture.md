# SDD — Application Architecture

| | |
|---|---|
| **Feature** | Foundational layering, dependency rule, state & model conventions |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `architecture` (scaffolds the base app), `new-module` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Define the structural contract every GSE Flutter app inherits: how code is layered, which
direction dependencies may point, and the canonical shape of state and models. This is the frame
all other SDDs assume.

| In scope | Out of scope |
|---|---|
| Layer boundaries + dependency rule | Concrete features (own docs) |
| State management convention (BLoC + status enums) | API transport (`core/api-client.md`) |
| Model / entity convention (Freezed) | Error model (`core/error-handling.md`) |
| Immutability + code-gen | DI mechanics (`core/dependency-injection.md`) |

### 1.1 Terminology
- **Layer** — one of `core`, `data`, `domain`, `presentation`.
- **Dependency rule** — the allowed direction of imports between layers.
- **Status enum** — an explicit state enum (e.g. `initial/loading/success/failure`) instead of boolean flags.

---

## 2. Constraints (architectural)

- Four layers under `lib/`: `core/`, `data/`, `domain/`, `presentation/`.
- State management is **BLoC/Cubit** (`flutter_bloc`); concurrency via `bloc_concurrency`
  transformers (`restartable()` for fetches, `droppable()` for submits).
- Immutability & equality via **Freezed** (`freezed`), including bloc state — `copyWith`,
  equality, `toString` are generated. **Not Equatable.**
- Bloc state models progress with a **status enum**, not boolean flags; on failure, prior data is retained.
- Repositories return **`Result<S, Failure>`** (see `core/error-handling.md`); blocs `switch` on it — no try/catch in the bloc.
- Wiring via **get_it** (`core/dependency-injection.md`); UI scoping via `BlocProvider`.

**Dependencies (pub):** `flutter_bloc: ^9.1.1`, `bloc: ^9.2.0`, `bloc_concurrency: ^0.3.0`,
`freezed_annotation: ^3.0.0`, `get_it: ^9.2.0` + dev `freezed: ^3.0.0`, `build_runner: ^2.4.0`.

**Existing-app variant:** a non-GSE app may use `Equatable` + manual `toJson/fromJson` and
boolean flags, and try/catch-in-bloc, to satisfy the same contracts without Freezed/`Result`.

> 🔎 "Freezed", "status enums", "four layers", "Result at repo" are spec — GSE mandates them.
> The internal event list of any bloc is not; it never appears in an SDD.

---

## 3. Layers & Dependency Rule

```
presentation ──► data ──► domain
       │           │         ▲
       └───────► core ◄──────┘        (core depends on nothing app-specific)
```

| Layer | Holds | May depend on | Must NOT depend on |
|---|---|---|---|
| `core/` | cross-cutting services (api, storage, routes, theme, env, utils, `Result`) | Flutter/pubs only | data, domain, presentation |
| `domain/` | Freezed models/entities, domain services | core | data, presentation |
| `data/` | repositories, form inputs, DTO/mapping | core, domain | presentation |
| `presentation/` | blocs, screens, widgets | core, domain, data | — |

**Dependency rule:** dependencies flow `presentation → data → domain`, with `core` as leaf
cross-cutting. `presentation` never touches a data source directly — only a repository. `domain`
never imports `data` or UI.

---

## 4. State Management Convention (observable contract)

Every stateful feature exposes a BLoC/Cubit whose **states are observable and testable**:

| Property | Contract |
|---|---|
| State object | Freezed, immutable, updated via generated `copyWith` |
| Progress | A **status enum** observable across the operation (not a boolean) |
| Failure | A typed `Failure` observable on error; prior data **retained** |
| Concurrency | Fetch events `restartable`; submit events `droppable` |

Documented bloc variants (in the `new-bloc` skill): (1) simple fetch, (2) preload + operation
(dual status enums), (3) list + local mutation (no re-fetch after mutating).

> 🔎 The SDD names these *observable* properties. It does NOT name events, handlers, or the
> concrete state class — the `new-bloc` skill decides those.

---

## 5. Model / Entity Convention

- Domain models live in `domain/models/…`, are **Freezed**, immutable.
- Default serialization: **Freezed + `json_serializable`** auto-generated (`fromJson`/`toJson`
  via `build_runner`). For models needing custom shaping, use `@Freezed(fromJson:false,toJson:false)`
  with hand-written `fromJson`/`toJson` (e.g. the base `User`).
- Mapping raw API payloads → domain models tolerates malformed records (skip + log via `AppLogger`).

---

## 6. Data Design

Not applicable at this level — each feature owns its data. This doc constrains *where* data types
live (§5) and *who* constructs them (repositories/mappers in `data`, models in `domain`).

---

## 7. Security Considerations

Sensitive values never live in `presentation` or plaintext storage; they flow through `core`
services (`core/storage.md`). The dependency rule prevents UI from reaching secrets directly.

---

## 8. Error Handling

Repositories return `Result<S, Failure>`; the API layer throws a typed `ApiException` that
repositories map to a semantic `Failure` enum. Blocs `switch` on `Result` — no exception reaches
a widget uncaught. Full contract in `core/error-handling.md`.

---

## 9. Acceptance Criteria & Invariants

- **A1.** Static import check: no file in `domain/` imports `data/`, `presentation/`, or Flutter UI widgets.
- **A2.** No widget/screen imports a data source or `Dio` directly — only repositories via DI.
- **A3.** Every bloc state is a Freezed type; state changes go through generated `copyWith`.
- **A4.** Bloc progress is represented by a status enum, not boolean flags.
- **A5.** A failed operation retains prior data (only status + failure change).

**Invariants**
- **I1.** Dependency direction never points from an inner layer outward (`domain` imports nothing app-specific).
- **I2.** A repository is the only bridge between a bloc and a data source.
- **I3.** Raw payload mapping never crashes the caller on a single malformed record.

---

## 10. Risks & Open Questions

- **R1.** Freezed + build_runner adds a codegen step; keep `build_runner` in CI and document the
  generate command. Existing apps migrating from manual JSON do so incrementally.
- **R2.** Group by domain area vs. technical type consistently across layers; decide per app and hold the line.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Layer tree | `base_app/lib/{core,data,domain,presentation}/` |
| Bloc/Cubit convention | `base_app/lib/presentation/blocs/**` (e.g. `blocs/app/`, `blocs/auth/auth_cubit.dart`) |
| Freezed model (auto) | `base_app/lib/domain/models/example_model.dart` |
| Freezed model (manual JSON) | `base_app/lib/domain/models/user.dart` |
| Result type | `base_app/lib/core/utils/result.dart` |

Paired skill: `architecture` (generates the base app honoring this contract), `new-module`, `new-model`.
