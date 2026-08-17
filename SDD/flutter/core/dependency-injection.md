# SDD — Dependency Injection

| | |
|---|---|
| **Feature** | Service-locator registration, phases, and object lifetimes |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `new-module`, `new-repository`, `new-bloc` (each registers its objects) |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Define how services, repositories, and blocs are constructed and wired so features declare
dependencies without knowing how they are built, and lifetimes are predictable.

| In scope | Out of scope |
|---|---|
| Registration phases + order | Widget-tree scoping details (`core/navigation.md`) |
| Object lifetimes (singleton/factory) | What each service does (its own doc) |
| UI provisioning boundary | App bootstrap sequence |

### 1.1 Terminology
- **Service locator** — a registry (get_it) resolving a type to an instance.
- **Lazy singleton** — created once, on first resolution. **Factory** — new instance per resolution.

---

## 2. Constraints (architectural)

- Wiring uses **get_it**, initialized before `runApp`.
- Registration happens in **three ordered phases**: **services → repositories → blocs** (services
  first because repositories depend on them; services may init async and are awaited).
- **Lifetimes:** services and repositories = **lazy singletons**; blocs/cubits = **factories**.
- UI obtains blocs via **`BlocProvider`/`MultiBlocProvider`**, resolving from the locator — the
  locator is not called ad-hoc deep in the widget tree.

**Dependencies (pub):** `get_it: ^9.2.0`, `flutter_bloc: ^9.1.1` (`BlocProvider`/`MultiBlocProvider`).

> 🔎 The phase order and lifetime rules are the spec. The exact list of registered types is
> implementation and lives in code, not here.

---

## 3. Observable Behavior

| Object kind | Lifetime | Rationale |
|---|---|---|
| Services (storage, api client, platform) | Lazy singleton | Shared, expensive to build |
| Repositories | Lazy singleton | Stateless orchestrators over services |
| Blocs / cubits | Factory | Per-screen state must not leak between routes |

---

## 4. Behavioral Flow

1. `main()` ensures bindings, then runs DI init.
2. DI init runs phase 1 (services, awaited) → phase 2 (repositories) → phase 3 (blocs).
3. A screen is provided its bloc through `BlocProvider(create: (_) => sl<XBloc>())`.
4. The bloc receives its repositories via constructor injection from the locator.

---

## 5. Interface

Registration surface: `registerLazySingleton<T>`, `registerFactory<T>`, `registerSingleton<T>`
(pre-built instances), resolved via `sl<T>()`.

---

## 6. Data Design

- External libraries (preferences, http, secure storage) register first as base services others depend on.
- In-memory caches that must persist across screens register as (eager) singletons.

---

## 7. Security Considerations

Secret-holding services (token manager) are singletons — they read secure storage on demand
rather than caching secrets in memory longer than needed.

---

## 8. Error Handling

- A failed async service init during phase 1 must fail bootstrap loudly, not continue half-wired.
- Resolving an unregistered type is a programming error surfaced in development, not swallowed.

---

## 9. Acceptance Criteria & Invariants

- **A1.** Two resolutions of the same service/repository type return the **same** instance.
- **A2.** Two resolutions of the same bloc type return **different** instances.
- **A3.** Navigating away and back to a screen yields a fresh bloc with initial state.
- **A4.** Services requiring async setup are fully initialized before any repository/bloc uses them.

**Invariants**
- **I1.** Blocs are never registered as singletons (no cross-route state leakage).
- **I2.** Features declare dependencies via constructor injection, not by reaching into the locator internally.

---

## 10. Risks & Open Questions

- **R1.** A global locator can hide dependency graphs — keep constructors explicit so the graph stays readable.
- **R2.** Eager singletons increase startup cost — register eagerly only when justified.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Init entry + phase order | `base_app/lib/main_injector.dart` |
| Services phase | `base_app/lib/core/services/services_injector.dart` |
| Repositories phase | `base_app/lib/data/repositories/repositories_injector.dart` |
| Blocs phase | `base_app/lib/presentation/blocs/blocs_injector.dart` |

Paired skills: `new-module`, `new-repository`, `new-bloc` (each adds its registrations to the right phase).
