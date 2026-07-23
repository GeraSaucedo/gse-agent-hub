# AGENTS.md — JERRY Agents Hub

Central, reusable hub of agent **roles**, **skills**, and **workflows** for software
development. No application code lives here. Assets are stack-agnostic by default and
specialized per stack under `.agents/skills/<stack>/`.

## How this hub is organized
- `.agents/roles/` — agent role definitions (planner, implementer, reviewer, tester). Stack-agnostic.
- `.agents/skills/<stack>/` — how-to manuals for a stack (e.g. `flutter/`). Each stack folder has its own `AGENTS.md` (conventions) plus one folder per skill with a `SKILL.md`.
- `.agents/skills/_shared/` — cross-stack skills (e.g. `code-quality`).
- `.agents/workflows/` — flow rules: node order, retries, human approval gates.

## How to apply this hub to a real project
1. In the target repo, create a thin `AGENTS.md` that links to the relevant stack folder here.
2. Copy or symlink the needed `skills/<stack>/` into the project.
3. Pick a workflow from `workflows/` and adjust its approval gates.

## Hard prohibitions (never, on any stack)
- **No git.** Agents never run git — no add, commit, push, branch, merge, or any git command. The human owns all version control. Prepare changes in the working tree only.
- **No reading secrets/config env.** Never read `.env` files or process environment variables.
- **No reading Flutter compile-time defines.** Never read `--dart-define` values or `String.fromEnvironment`/`bool.fromEnvironment` inputs.
- Deleting or overwriting files the agent didn't create needs explicit approval.

## Global engineering standards (all stacks)
- **KISS, no over-engineering.** Pick the simplest solution that works; add complexity only when a real failure demands it. Prefer a loop over a graph until then.
- **Read before writing.** Inspect existing code/conventions; match them, don't invent.
- **One source of truth.** Don't duplicate a rule across files — link to it.
- **Every instruction earns its place.** If it's inferable from the code or the framework, omit it.
- **Tests are part of "done."** No feature is complete without passing tests for it.
- **Report faithfully.** If tests fail or a step was skipped, say so with evidence.

## Truthfulness — anti-hallucination (all agents)
- **You are allowed to be wrong and to not know.** Prefer "I don't have enough information to answer this confidently" over a confident guess. Never fabricate to fill a gap.
- **Verify before asserting.** Don't claim an API, file, function, config key, or flag exists — read/grep to confirm it first. Never invent identifiers or library methods.
- **Ground claims in sources.** Back code claims with `file:line`; back external facts with a URL. If you can't point to a source, mark it an assumption or drop it.
- **Search when unsure.** If a fact may be outdated or you're not certain, search the web (when available) before answering; note the date of what you find.
- **Separate verified from inferred.** State plainly what you confirmed vs. what you're guessing.
- **Retract, don't defend.** If a claim can't be supported on review, remove it.
- **Escalate on missing info.** When you lack what you need, ask or flag it — don't invent plausible fiction.

## Authoring conventions for this hub
- Language: **English** for all operational files (roles, skills, workflows). Business context may be Spanish.
- Length budget: root `AGENTS.md` 30–80 lines · each stack `AGENTS.md` ≤ 60 lines · each `SKILL.md` 50–150 lines (hard cap 500).
- `SKILL.md` uses YAML front-matter with `name` and `description`.
- Keep bridge files (`CLAUDE.md`, `GEMINI.md`) at 1–3 lines pointing here.
