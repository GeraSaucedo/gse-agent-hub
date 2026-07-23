---
name: refactor-review
description: Review the current session's changes and the module they touch, and propose whether a refactoring or design pattern is genuinely warranted. Read-only analysis; grounds every proposal in the code and gates it by KISS. Produces proposals, not edits.
---

# Skill: Refactor review (cross-stack)

Look at what this session changed, widen to the surrounding code it affects, and answer one
question honestly: **is a refactoring or design pattern warranted here — now — or not?**
Uses the `code-smells` catalog to name problems and `design-patterns` to name fixes; both
under `.agents/skills/_shared/`. This is analysis only — it proposes, it does not rewrite
(hand accepted proposals to the Planner/Implementer, like the `reviewer` role).

## When to use
After a change is made, before the human gate — as an optional analysis pass in the
feature-dev workflow, or on demand ("is this module ripe for a refactor?").

## Scope — session-first, then the blast radius
1. **Start from the session's changed files.** The diff/working-tree changes are the anchor.
2. **Widen to the module they live in and the code they interact with** — sibling files in the
   same feature/layer folder, the callers and callees the change touches. Enough context to
   judge structure, not the whole repo.
3. **Stop at the module boundary.** Don't audit unrelated areas; if you spot something far
   outside, note it in one line and move on. Silent scope-creep is itself a smell.

> Example: a task adds a payment method. Reviewing only the diff, you'd see one `if`. Widening
> to the payments module, you find three payment types already branching on a type code in
> several places (*Switch Statements* / *Divergent Change*) — **now** Strategy or State is
> justified. Had it been the first payment type, the plain `if` wins (YAGNI).

## Method
1. **Detect smells** across the scope using `code-smells`. Name each precisely; a symptom that
   fits several smells is named by the cure that fits.
2. **Map each confirmed smell to its refactoring** (and, only if it earns the indirection, a
   `design-patterns` entry).
3. **Apply the KISS gate — a proposal survives only if ALL hold:**
   - the pain is **present and repeated** (rule of three), not hypothetical;
   - the change **improves health now** and isn't *Speculative Generality*;
   - the payoff **beats the indirection cost** the refactor/pattern adds;
   - it stays within a reasonable blast radius for the value gained.
4. **Ground it.** Every proposal cites `file:line` for the smell. No evidence → no proposal.
5. **Try to refute each proposal before keeping it** (precision over recall — see `reviewer`).
   A refactor-review that cries wolf gets ignored.

## Output
- A prioritized list. Each proposal:
  - **Smell** — the named smell + `file:line` evidence (the repetition, not one instance).
  - **Proposed refactoring / pattern** — the concrete move (e.g. "Replace Conditional with
    Polymorphism → Strategy for payment methods").
  - **Why now** — the present, repeated pain that justifies it (not "good practice").
  - **Effort / risk / blast radius** — files affected, callers touched, reversibility.
  - **Skip if** — the condition under which it's *not* worth it (keeps the human honest).
- An explicit **"no refactor warranted in scope X"** when the code is clean — a clean verdict is
  a valid, valuable result, not a failure to find work.

## Constraints
- **Propose only; never edit, run git, or deploy.** Accepted proposals go back through the
  Planner → Implementer loop so tests and review cover them.
- **Default to "no".** The bar is present pain that outweighs added indirection; when unsure,
  don't propose. Textbook-correctness is not justification.
- **Don't re-litigate requirements or hunt for bugs** — correctness is the `reviewer`'s and
  `tester`'s job; you own structure/design health only.
- Respect stack conventions: a stack `AGENTS.md` may already mandate a structure — align with
  it, don't propose something that contradicts it.
- Never read `.env`, environment variables, or Flutter defines.
