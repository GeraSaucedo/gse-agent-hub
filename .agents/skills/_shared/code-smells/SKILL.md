---
name: code-smells
description: Catalog of code smells (after Refactoring Guru) grouped into five families, each mapped to the refactoring that cures it. Consult when reviewing code for structural debt or deciding whether a refactor is warranted.
---

# Skill: Code smells (cross-stack)

A shared vocabulary of recurring structural problems and the refactoring each implies.
Taxonomy follows Refactoring Guru (Fowler's *Refactoring*). This is the reference catalog;
for the decision of **whether to act on a smell**, see `refactor-review`
(`.agents/skills/_shared/refactor-review/SKILL.md`); for patterns a fix may introduce, see
`design-patterns` (`.agents/skills/_shared/design-patterns/SKILL.md`).

## When to use
Reviewing or writing code on any stack, or naming what's wrong with existing code precisely.

## The gate before any refactor (KISS)
- **A smell is a suspicion, not a verdict.** Confirm present, repeated pain before acting.
- **Rule of three.** Don't abstract away duplication until the third occurrence.
- **Every refactor must improve health *now*** — not guard against an imagined future (that's
  itself the *Speculative Generality* smell). Indirection you don't need is a cost, not a win.

## Bloaters — code that has grown too large to reason about
| Smell | Tell | Cure (refactoring) |
|---|---|---|
| **Long Method** | Can't summarize it without "and". | Extract Method; Replace Temp with Query; Decompose Conditional. |
| **Large Class** | Too many fields/responsibilities. | Extract Class / Subclass / Interface. |
| **Primitive Obsession** | Concepts modeled as raw `String`/`int`/maps. | Replace Data Value with Object; Introduce Parameter Object; Replace Type Code with Class. |
| **Long Parameter List** | >~3 params, or flags. | Introduce Parameter Object; Preserve Whole Object; Replace Parameter with Method Call. |
| **Data Clumps** | Same group of fields travels together everywhere. | Extract Class; Introduce Parameter Object; Preserve Whole Object. |

## Object-orientation abusers — OO applied incompletely
| Smell | Tell | Cure |
|---|---|---|
| **Switch Statements** | Same `switch`/`if` on a type code in many places. | Replace Conditional with Polymorphism; Replace Type Code with State/Strategy/Subclasses. |
| **Temporary Field** | Field set only in some paths, empty otherwise. | Extract Class; Introduce Null Object. |
| **Refused Bequest** | Subclass ignores/overrides most of its parent. | Replace Inheritance with Delegation; Extract Superclass. |
| **Alternative Classes, Different Interfaces** | Two classes do the same job, incompatible APIs. | Rename Methods; Move Method; Extract Superclass. |

## Change preventers — one change forces many edits
| Smell | Tell | Cure |
|---|---|---|
| **Divergent Change** | One class changes for many unrelated reasons. | Extract Class (split by reason to change). |
| **Shotgun Surgery** | One change forces edits scattered across many classes. | Move Method/Field to consolidate; Inline Class. |
| **Parallel Inheritance Hierarchies** | Adding a subclass here forces one there. | Move Method; Move Field to merge hierarchies. |

## Dispensables — things whose absence makes code cleaner
| Smell | Tell | Cure |
|---|---|---|
| **Comments (that explain *what*)** | Comment paraphrasing the next lines. | Extract Method; Rename; Introduce Assertion (keep only *why* comments). |
| **Duplicate Code** | Same logic in >1 place. | Extract Method; Pull Up Method; Form Template Method; Extract Superclass. |
| **Dead Code** | Unreachable / never-called. | Delete it (git remembers). |
| **Lazy Class** | Class that no longer earns its keep. | Inline Class; Collapse Hierarchy. |
| **Data Class** | Fields + getters/setters, no behavior. | Move Method (put behavior with its data); Encapsulate Field/Collection. |
| **Speculative Generality** | "We might need it" abstraction with one user. | Collapse Hierarchy; Inline Class; Remove Parameter (YAGNI). |

## Couplers — excessive coupling between classes
| Smell | Tell | Cure |
|---|---|---|
| **Feature Envy** | Method uses another object's data more than its own. | Move Method; Extract Method then move. |
| **Inappropriate Intimacy** | Two classes reach into each other's internals. | Move Method/Field; Extract Class; Hide Delegate; Replace Inheritance with Delegation. |
| **Message Chains** | `a.getB().getC().getD()`. | Hide Delegate; Extract + Move Method. |
| **Middle Man** | Class that only delegates onward. | Remove Middle Man; Inline Method. |

## Notes
- A single symptom can fit several smells — name the one whose *cure* fits, not the label.
- Stack-specific smells (e.g. Flutter deep `build` trees, business logic in widgets) live in the
  stack's `AGENTS.md` and override this when they conflict.
