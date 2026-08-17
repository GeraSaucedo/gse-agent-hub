# SDD — Storage

| | |
|---|---|
| **Feature** | Secure + local persistence contract and domain managers |
| **Status** | `Reference (GSE base)` |
| **Layer** | Core |
| **Pairs with skill** | `architecture` |
| **Author** | GSE Agent Hub |
| **Last updated** | 2026-08-17 |

---

## 1. Purpose & Scope

Define a uniform persistence contract with two backends split by data sensitivity, and the
"manager" pattern that wraps them for a specific domain (tokens, user, config, onboarding).

| In scope | Out of scope |
|---|---|
| Storage interface (read/write/delete/clear) | Token lifecycle (`auth/*`) |
| Secure vs local backend selection | Remote/offline sync (deferred) |
| Manager pattern over storage | Cache-with-TTL policies (feature docs) |

### 1.1 Terminology
- **Secure storage** — OS-encrypted store (iOS Keychain / Android Keystore-backed).
- **Local storage** — plaintext key/value (shared preferences).
- **Manager** — a domain-specific wrapper (e.g. token manager) over a storage backend.

---

## 2. Constraints (architectural)

- One **abstract `StorageService`** with generic `write<T>`/`read<T>`/`delete`/`clear`.
- Two implementations: **secure** (`flutter_secure_storage`) and **local** (`shared_preferences`).
- Consumers use **managers**, not raw storage keys scattered across the codebase.
- Backend choice is by **sensitivity**, not convenience.

**Dependencies (pub):** `flutter_secure_storage: ^10.0.0` (secure), `shared_preferences: ^2.5.4` (local).
Structured local data / future offline (Extension): `sqflite`.

**Existing-app variant:** same contract; only package versions differ.

> 🔎 "Sensitive → secure, non-sensitive → local" is the contract. Which exact keys a manager owns
> is implementation detail, but the *placement rule* is spec and is testable.

---

## 3. Observable Behavior

| Data class | Backend | Example |
|---|---|---|
| Secrets / credentials / tokens | Secure | access/refresh token, `userSub` |
| Non-sensitive flags / cache | Local | onboarding-seen flag, cached user/config JSON |

A value written is readable until explicitly deleted or cleared; `clear` on logout removes a manager's entire key set.

---

## 4. Behavioral Flow

1. A manager exposes intent-named methods (`saveX`, `getX`, `clearX`).
2. The manager routes each value to the correct backend by sensitivity.
3. `read` returns typed value or null; `delete`/`clear` remove keys.

---

## 5. Interface

`StorageService`: `write<T>(key, value)`, `read<T>(key) → T?`, `delete(key)`, `clear()`.
Local storage supports `int, double, String, bool, List, Map` (JSON-encoded for collections).

---

## 6. Data Design

Managers own a fixed, documented key set. Base managers:
- **Token manager** → access/refresh token + `userSub` (secure).
- **User manager** → serialized user JSON (local).
- **Config manager** → app config (local).
- **Onboarding manager** → onboarding-seen flag (local).

Sensitive keys never appear in local storage.

---

## 7. Security Considerations

- Tokens and any PII secret go to secure storage only.
- `clear`/logout must remove **all** secure keys for the session (see `auth/logout.md` I3).
- Local storage is world-readable on rooted/jailbroken devices — never place secrets there.

---

## 8. Error Handling

- A failed secure read returns null (treated as "absent"), never crashes the caller.
- Local JSON serialization failures are logged and treated as absent.

---

## 9. Acceptance Criteria & Invariants

- **A1.** A value classified sensitive is written to secure storage and is **absent** from local storage.
- **A2.** `read` of a never-written key returns null, not an error.
- **A3.** A manager's `clear` removes every key it owns.
- **A4.** Collections written to local storage round-trip via JSON without loss.

**Invariants**
- **I1.** No secret is ever persisted in local storage.
- **I2.** Storage keys are accessed only through a manager, never as raw literals in features.

---

## 10. Risks & Open Questions

- **R1.** Secure storage semantics differ across platforms (backup, biometric-gating). Decide whether keys survive OS backup/restore.
- **R2.** No encryption-at-rest for large local blobs (cached user/config). Acceptable if non-sensitive; re-evaluate as cached data grows.

---

## 11. Traceability / Pairs-with

| Concern | File (GSE base_app) |
|---|---|
| Storage contract | `base_app/lib/core/services/storage/contract/storage_service.dart` |
| Secure impl | `base_app/lib/core/services/storage/implementations/secure_storage_service.dart` |
| Local impl | `base_app/lib/core/services/storage/implementations/local_storage_service.dart` |
| Managers | `base_app/lib/core/services/storage/utils/{token_manager,user_manager,config_manager,onboarding_manager}.dart` |

Paired skill: `architecture`.
