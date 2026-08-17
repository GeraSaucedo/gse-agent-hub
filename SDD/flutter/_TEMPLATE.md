# SDD — <Feature name>

<!--
  Canonical SDD skeleton for the GSE Flutter kit.
  Copy this file, rename to kebab-case (e.g. `checkout.md`), delete the 🔎 callouts,
  and fill each section. Delete sections that genuinely don't apply — do not pad.
  Altitude rule (read once): describe WHAT must be true and the OBSERVABLE behavior.
  Never describe internal BLoC events/handlers, class names, or file layout — that is
  the paired skill's job (the "how"). If a sentence would break when someone rewrites
  the bloc with a different internal structure, it does not belong here.
-->

| | |
|---|---|
| **Feature** | <what this covers> |
| **Status** | `Reference (GSE base)` \| `Extension (ientc)` \| `Proposed (greenfield)` |
| **Layer** | Core \| Auth \| Cross-cutting \| Domain |
| **Pairs with skill** | `<skill name>` (the *how*) — this doc is the *what* |
| **Author** | <name> |
| **Last updated** | YYYY-MM-DD |

> 🔎 **Status.** `Reference (GSE base)` = proven in the GSE `base_app` (the baseline new apps
> inherit); Section 11 cites base_app files. `Extension (ientc)` = proven in
> `flutter_ientc_empleados`, optional, beyond the GSE base; Section 11 cites ientc files.
> `Proposed (greenfield)` = standard/expected but not built anywhere yet — omit Section 11, keep the banner.

---

## 1. Purpose & Scope

One paragraph: what this feature guarantees.

| In scope | Out of scope |
|---|---|
| … | … (link the doc that owns it) |

> 🔎 Split login vs. authentication-style concerns explicitly. A doc that tries to own
> everything becomes unmaintainable. Push adjacent concerns to their own docs and link them.

### 1.1 Terminology
Define only terms whose meaning is non-obvious or overloaded.

---

## 2. Constraints (architectural — these ARE part of the spec)

Bullet the non-negotiable technical constraints the implementation must honor.
For the GSE Flutter kit the defaults are: state = BLoC, forms = Formz, DI = get_it,
routing = go_router, secure data = flutter_secure_storage. Restate only the ones that matter here.

**Dependencies (pub):** list the exact packages + versions this feature needs (see the GSE
base stack in `README.md`), so a new project can add them. Name the *package*, not just the concept.

**Existing-app variant** *(optional)*: if the contract is achievable with older mechanics
(Equatable + manual JSON instead of Freezed; try/catch-in-bloc instead of `Result`), note it in
one line so a non-GSE app can adopt the same *contract* without the newer packages.

> 🔎 A constraint ("state management is BLoC") is spec because the project mandates it.
> The bloc's internal event list is NOT — never list it.

---

## 3. Observable States

The one state machine the implementation must honor, in terms an outside observer can see.

| State | Meaning | UI / effect |
|---|---|---|
| … | … | … |

```
stateA ──(trigger)──► stateB ──(outcome)──► stateC
```

> 🔎 These are *observable* states, not BLoC state class names. Any internal mapping that
> honors this table is correct.

---

## 4. Behavioral Flow

Numbered steps of the happy path + branches. Reference states from Section 3.

---

## 5. Interface

Endpoints / platform APIs this feature depends on. Keep backend-agnostic: describe the
*contract* (method, purpose, request/response shape), not a specific vendor URL.

| Endpoint | Method | Purpose | Request → Response |
|---|---|---|---|
| `<path>` | … | … | … |

---

## 6. Data Design

Entities, tokens, persisted values, and *where* they live (secure vs local). Fields and invariants.

---

## 7. Security Considerations

What is protected, how, and what is explicitly NOT done (documented absences, not oversights).

---

## 8. Error Handling

| Condition | Behavior |
|---|---|
| … | … |

---

## 9. Acceptance Criteria & Invariants  ← test source of truth

Tests derive from here — one test per criterion. Do NOT put the tests themselves in the doc.

- **A1.** <Given … when … then …> (executable statement)
- **A2.** …

**Invariants (must always hold)**
- **I1.** …

> 🔎 This section is why the doc exists. If you cannot phrase a criterion, the feature is
> under-specified — resolve that before implementing. Invariants shared across sibling docs
> live in the family's `overview.md` and are referenced, never copy-pasted.

---

## 10. Risks & Open Questions

Known limitations, trade-offs made, and decisions still owed. Number risks (R1, R2…) so
other docs can reference them.

---

## 11. Traceability / Pairs-with

*(Reference docs only — delete for Proposed/greenfield.)*

| Concern | File (in reference impl) |
|---|---|
| … | `lib/…` |

Paired skill: `<skill>` — invoke it to generate the structure that satisfies this contract.
