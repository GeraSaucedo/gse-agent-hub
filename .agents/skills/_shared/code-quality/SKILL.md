---
name: code-quality
description: Cross-stack code standards — clean code, SOLID, avoiding code smells, and when (and when not) to reach for a design pattern. Consult when writing or reviewing any code.
---

# Skill: Code quality (cross-stack)

Universal standards. Stack-specific rules live in each `skills/<stack>/AGENTS.md`
and take precedence when they conflict. Above all: **KISS — the simplest thing
that works. Don't over-engineer.**

## When to use
Writing or reviewing code on any stack.

## Clean code
- **Names reveal intent.** No abbreviations or single letters (except trivial loop indices).
- **Small functions, one job.** If you need "and" to describe it, split it.
- **Few parameters.** More than ~3 → group into an object/struct.
- **No magic values.** Name constants. No unexplained numbers/strings.
- **Comments explain *why*, not *what*.** The code shows what; don't narrate it.
- **Fail fast.** Guard clauses over deep nesting; return early.

## SOLID (apply with judgement, not dogma)
- **S**ingle responsibility — one reason to change per unit.
- **O**pen/closed — extend without editing stable code, *when* variation is real.
- **L**iskov — subtypes must honor the base contract.
- **I**nterface segregation — small, focused interfaces over fat ones.
- **D**ependency inversion — depend on abstractions; point dependencies inward (see architecture).

## Code smells & refactoring
- Watch for the usual families: bloaters (long method/class, primitive obsession, long param
  lists), change preventers (divergent change, shotgun surgery), dispensables (dead code,
  duplication, speculative generality), and couplers (feature envy, message chains).
- The full catalog — each smell mapped to the refactoring that cures it — lives in the
  `code-smells` skill (`.agents/skills/_shared/code-smells/SKILL.md`). Don't restate it here.
- To decide whether a smell is worth acting on *now*, use `refactor-review`
  (`.agents/skills/_shared/refactor-review/SKILL.md`). Default: rule of three, present pain only.

## Design patterns
- Patterns are a vocabulary, not a goal. Reach for one only when it removes real, present pain
  — never to look sophisticated. Every pattern adds indirection; unneeded indirection is a smell.
- The GoF catalog with the situation that justifies each lives in the `design-patterns` skill
  (`.agents/skills/_shared/design-patterns/SKILL.md`).

## Architecture (clean architecture)
- **Dependencies point inward:** domain ← application ← data/presentation. Inner
  layers know nothing about outer ones.
- Business rules don't import frameworks, UI, or I/O. Keep them pure and testable.
- Cross boundaries through interfaces/abstractions, not concrete outer types.
- Keep the layering only as strict as the project size warrants — don't build a
  four-layer cathedral for a small module (KISS).

## Definition of done (quality lens)
- No new smells from the list above; linter/analyzer clean.
- Any pattern or abstraction added is justified by a present need, not a future guess.
