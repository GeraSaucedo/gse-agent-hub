# JERRY Agents Hub

Central, reusable hub of AI-agent **roles**, **skills**, and **workflows** for software
development. Multi-stack: shared assets at the top, stack-specific manuals under each stack.

> Operational files are in English (models follow instructions better in English and the
> ecosystem standard is English). This human README can stay bilingual.

## Layout
| Path | What it is | Scope |
|---|---|---|
| `AGENTS.md` | Global standards + hub map | All stacks |
| `.agents/roles/` | Agent role prompts (planner, implementer, reviewer, tester, security-reviewer, documentarian) | Stack-agnostic |
| `.agents/skills/_shared/` | Cross-stack skills (`code-quality`) | All stacks |
| `.agents/skills/<stack>/` | Per-stack conventions (`AGENTS.md`) + how-to skills (`SKILL.md`) | One stack |
| `.agents/workflows/` | Flow rules: order, retries, approval gates | Stack-agnostic |

## Concepts (quick recap)
- **Role** = a prompt/responsibility + tools + a model. The *who*.
- **Skill** = a reusable manual teaching *how* to do one task well. Consulted, not run.
- **Workflow** = the map ordering roles, with retry and human-approval rules. The *when/what-next*.

## Model per role
Match model power to the reasoning the role needs — don't run the top model for everything
(that's how you save tokens without losing quality). Tiers map to any provider; Claude
examples shown. Set the model when you instantiate the agent, not in the role file.

| Role | Tier | Why | Claude example |
|---|---|---|---|
| Planner | **Top** | Debate, architecture, trade-offs, web research — the hardest reasoning | Opus 4.8 |
| Security Reviewer | **Top** | Subtle vulnerabilities are high-stakes and easy to miss | Opus 4.8 |
| Reviewer | **Strong** | Catching real bugs needs solid reasoning; bump to top for high-risk changes | Sonnet 4.6 (Opus 4.8 if risky) |
| Implementer | **Strong** | Follows a set plan + skills; bump to top for complex steps | Sonnet 4.6 (Opus 4.8 if complex) |
| Tester | **Mid** | Writes/runs tests and diagnoses failures — some reasoning, not deep | Sonnet 4.6 |
| Documentarian | **Fast/cheap** | Mostly summarizing decisions already made | Haiku 4.5 |

## Add a new stack
1. `mkdir .agents/skills/<stack>` and write its `AGENTS.md` (conventions, ≤ 60 lines).
2. Add one folder per skill with a `SKILL.md` (YAML front-matter + 50–150 lines).
3. Reuse `roles/` and `workflows/` as-is.

## Apply the hub to a real project (copy / vendor)
Each project gets its own copy of `.agents/`. Simple and self-contained; to pick up later hub
improvements, re-copy. **Copy the reusable parts, not the hub's own top-level docs.**

**Copy as-is:**
1. Copy `.agents/` into the project root → `<project>/.agents/`.
2. Delete the stacks you don't use under `.agents/skills/` (keep only e.g. `flutter/`).
3. Add a bridge `CLAUDE.md` (and/or `GEMINI.md`) at the root — 1–3 lines pointing to `AGENTS.md`.

**Write fresh — don't paste the hub's versions:**
4. Write a **thin project `AGENTS.md`** at the root: the project's own context, linking to
   `.agents/skills/<stack>/AGENTS.md` and the global standards. Do **not** copy this hub's root
   `AGENTS.md` — it describes the hub ("no application code lives here") and is wrong for a real project.
5. Keep the project's own `README.md`. This hub's `README.md` documents the hub, not your project.

Then pick a workflow (e.g. `feature-dev.md`) and tune its approval gates.

## Current stacks
- `flutter/` — Dart + Flutter, **GSE architecture** (Clean layer-first, BLoC, go_router, dio, get_it, design_system + gse_localization). Skills: architecture (scaffold), flavors, new-module/new-model/new-repository/new-bloc/new-screen, check-arch, clean-code, testing. Scaffolding via `architecture/generate.mjs` (no VSCode extension needed).
