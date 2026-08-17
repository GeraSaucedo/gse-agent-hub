# SDD — Error Handling

| | |
|---|---|
| **Feature** | Two-layer error model: typed exceptions (API) + `Result<S,E>` (repository) |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `new-repository`, `new-bloc` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Define how failures are typed at the transport boundary, converted to semantic domain failures,
and consumed by blocs — so every feature handles errors identically and no exception reaches a
widget uncaught.

| In scope | Out of scope |
|---|---|
| `ApiException` hierarchy (API boundary) | Retry policy (`core/api-client.md`) |
| `Result<S, Failure>` at repository layer | Per-feature copy (feature docs) |
| `mapDioToFailure` conversion + overrides | Crash telemetry (deferred) |
| Bloc consumption via exhaustive `switch` | — |

### 1.1 Terminology
- **`ApiException`** — typed transport error thrown by the API client.
- **`Failure`** — a semantic, per-domain enum a repository returns (e.g. `AuthFailure.unauthorized`).
- **`Result<S, E>`** — a sealed success/failure wrapper returned by repositories.

---

## 2. Constraints (architectural)

- The API client throws a **typed `ApiException`** at its boundary (no raw `DioException` escapes).
- Repositories **catch `ApiException`, map to a semantic `Failure` enum, and return `Result<S, Failure>`** —
  they do not rethrow. Mapping uses a shared `mapDioToFailure<E>()` helper with per-call `statusOverrides`.
- Blocs consume `Result` with an **exhaustive `switch`** (`Success` / `Failure`) — **no try/catch in the bloc**.
- Logging via a custom **`AppLogger`**.

**Dependencies (pub):** `dio: ^5.9.1` (source errors, mapped at the boundary). No `Either`/monad
package — `Result<S,E>` is a local sealed class in `core/utils/`.

**Existing-app variant:** a non-GSE app may skip `Result` and instead catch typed exceptions
inside the bloc (try/catch → error state). Same taxonomy (§6), older mechanics.

> 🔎 GSE uses **both** layers deliberately: typed exceptions for transport, `Result` for the
> repository↔bloc contract. Restate this so a feature doesn't invent a third error model.

---

## 3. Observable States (error surface)

Any repository operation resolves to exactly one:

| Outcome | Observable |
|---|---|
| `Success(value)` | data state |
| `Failure(e)` — expected | error state with a specific, actionable message mapped from `e` |
| `Failure(e)` — unexpected | error state with a generic message |

Error state is **transient**: shown once, cleared on the next user action/retry; prior data retained.

---

## 4. Behavioral Flow

```
Dio error ─► ApiClient maps ─► throws ApiException
   ─► repository catch ─► mapDioToFailure/switch ─► return Result<T, XFailure>
   ─► bloc switch(result) { Success → data state ; Failure → status+message } ─► widget shows message
```

---

## 5. Interface

Not a network interface. The consumer-facing "interface" is:
- `Result<S, E>` = `sealed` with `Success<S,E>(value)` and `Failure<S,E>(exception)`.
- `mapDioToFailure<E>({statusOverrides})` — converts a caught `ApiException`/`DioException` to `E`.

---

## 6. Data Design

**API boundary taxonomy (`ApiException`):**

| Exception | Trigger |
|---|---|
| `BadRequestException` | 400 |
| `UnauthorizedException` | 401 |
| `ForbiddenException` | 403 |
| `NotFoundException` | 404 |
| `ConflictException` | 409 |
| `ServerException` | 5xx |
| `NoInternetException` / `TimeoutException` / `NetworkException` | connectivity/timeouts |
| `UnknownException` | unmapped |

**Repository boundary (semantic `Failure` enums):** per domain, e.g. `AuthFailure { unauthorized,
forbidden, client, server, network, timeout, unknown, invalidForm }`. Each feature defines its own.

---

## 7. Security Considerations

- User-facing messages never leak server internals, stack traces, or tokens.
- `AppLogger` may carry more detail but must redact credentials/tokens (see `core/api-client.md` §7).

---

## 8. Error Handling (mapping table)

| `ApiException` | Typical `Failure` | UX |
|---|---|---|
| `UnauthorizedException` | `unauthorized` | login error / session invalidated |
| `ForbiddenException` | `forbidden` | "no access" |
| `BadRequestException` | `client` | field/validation message |
| `ServerException` | `server` | generic retry |
| `NoInternet`/`Timeout` | `network`/`timeout` | "no connection", re-triggerable |
| other | `unknown` | generic; detail only in logs |

`statusOverrides` let a call remap a status (e.g. treat 409 as a domain-specific failure).

---

## 9. Acceptance Criteria & Invariants

- **A1.** A transport `4xx/5xx` reaches the repository as the matching `ApiException` (e.g. 409 → `ConflictException`).
- **A2.** A repository returns `Failure(<enum>)` for every mapped error and `Success(value)` otherwise — it never rethrows to the bloc.
- **A3.** A bloc handles `Result` with an exhaustive `switch`; there is no try/catch in the bloc.
- **A4.** A displayed error is cleared before the next attempt; prior data is retained.
- **A5.** No `presentation` file imports `DioException`.

**Invariants**
- **I1.** Exactly two error layers app-wide: `ApiException` (transport) and `Result`/`Failure` (repo↔bloc).
- **I2.** User-facing messages never contain raw exception text or tokens.

---

## 10. Risks & Open Questions

- **R1.** `Failure` enums proliferate per domain — keep them small and semantic; share `mapDioToFailure` to avoid drift.
- **R2.** Exhaustiveness relies on `sealed` switch; keep analyzer strict so a new `Failure` value forces handling.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| `Result<S,E>` sealed type | `base_app/lib/core/utils/result.dart` |
| Dio→Failure mapper | `base_app/lib/core/utils/dio_exception_mapper.dart` |
| `ApiException` hierarchy | `base_app/lib/core/services/api/error_mapping.dart` |
| Repo returning Result | `base_app/lib/data/repositories/auth/auth_repository.dart` (+ `auth_failures.dart`) |

Paired skills: `new-repository` (returns `Result`), `new-bloc` (switches on it).
