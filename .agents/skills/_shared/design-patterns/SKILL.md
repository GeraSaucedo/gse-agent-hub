---
name: design-patterns
description: Catalog of GoF design patterns (after Refactoring Guru) grouped creational/structural/behavioral, each with its intent and the concrete situation that justifies reaching for it. Consult when a code smell suggests a pattern might help.
---

# Skill: Design patterns (cross-stack)

A shared vocabulary of proven solutions. Catalog follows Refactoring Guru (GoF). This is
reference material; the decision of **whether a pattern is warranted here** belongs to
`refactor-review` (`.agents/skills/_shared/refactor-review/SKILL.md`), and the smells that
motivate a pattern live in `code-smells` (`.agents/skills/_shared/code-smells/SKILL.md`).

## When to use
When a confirmed smell (esp. *Switch Statements*, *Duplicate Code*, *Divergent Change*,
*Inappropriate Intimacy*) suggests structure would help — and you need the right name for it.

## The gate before applying any pattern (KISS)
- **Patterns are a vocabulary, not a goal.** Reach for one only when it removes real, *present*
  pain — never to look sophisticated.
- **Every pattern adds indirection.** Indirection you don't need is a smell (*Speculative
  Generality*). Prefer the plainest thing that works; introduce the pattern when duplication or
  change-friction actually shows up.
- **Match the pattern to the smell**, not the smell to a pattern you wanted to use.

## Creational — how objects get made
| Pattern | Intent | Reach for it when |
|---|---|---|
| **Factory Method** | Defer instantiation to subclasses. | Callers shouldn't know concrete types; new variants keep appearing. |
| **Abstract Factory** | Create families of related objects. | You must swap a whole consistent set (e.g. per platform/theme). |
| **Builder** | Build a complex object step by step. | Long constructor / many optional params (*Long Parameter List*). |
| **Prototype** | Clone an existing instance. | Creation is costly and a template instance exists. |
| **Singleton** | One shared instance. | Rarely — most DI containers replace it. Prefer injection. |

## Structural — how objects compose
| Pattern | Intent | Reach for it when |
|---|---|---|
| **Adapter** | Make an incompatible API fit. | Integrating a third party without leaking its shape. |
| **Bridge** | Split abstraction from implementation. | Two dimensions vary independently and multiply. |
| **Composite** | Treat tree and leaf uniformly. | Recursive part-whole structures. |
| **Decorator** | Add behavior without subclassing. | Optional, stackable responsibilities. |
| **Facade** | One simple entry to a complex subsystem. | Callers drown in a subsystem's surface area. |
| **Flyweight** | Share common state across many objects. | Huge object counts, mostly identical state. |
| **Proxy** | Stand-in controlling access. | Lazy loading, caching, access control, logging. |

## Behavioral — how objects interact
| Pattern | Intent | Reach for it when |
|---|---|---|
| **Chain of Responsibility** | Pass a request along handlers. | Several possible handlers, chosen at runtime. |
| **Command** | Encapsulate a request as an object. | Undo/redo, queuing, logging of actions. |
| **Iterator** | Traverse without exposing structure. | Custom collections needing uniform traversal. |
| **Mediator** | Centralize many-to-many chatter. | Objects reference each other in a tangle (*Inappropriate Intimacy*). |
| **Memento** | Capture/restore state. | Snapshots, undo without breaking encapsulation. |
| **Observer** | Notify dependents of change. | One-to-many event propagation (often built into the stack). |
| **State** | Behavior varies by internal state. | A type/state code drives big `switch`es (*Switch Statements*). |
| **Strategy** | Interchangeable algorithms. | Many variants of one operation selected at runtime (e.g. payment methods). |
| **Template Method** | Fix a skeleton, vary steps. | Duplicate algorithms differing only in steps (*Duplicate Code*). |
| **Visitor** | Add operations without changing classes. | New operations often, stable class hierarchy. |

## Notes
- Many stacks ship a pattern natively (Observer via streams, Strategy via function/closures,
  Singleton via DI). Use the built-in before hand-rolling the classic OO form.
- When in doubt between a pattern and a plain function, choose the function.
