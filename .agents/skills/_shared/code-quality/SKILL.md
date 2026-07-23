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

## Code smells to avoid
- Duplication (DRY) — but don't abstract until the third occurrence.
- Long functions / large classes / long parameter lists.
- Deep nesting and complex conditionals — extract or invert.
- Feature envy / inappropriate intimacy — logic living far from its data.
- Dead code, commented-out code, speculative "just in case" generality (YAGNI).
- Primitive obsession — model concepts as types, not raw strings/ints.

## Design patterns
- Patterns are a vocabulary, not a goal. Reach for one only when it removes real,
  present pain — never to look sophisticated.
- Prefer the plainest solution first; introduce a pattern when duplication or
  change-friction actually shows up.
- Know the cost: every pattern adds indirection. Indirection you don't need is a smell.

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
