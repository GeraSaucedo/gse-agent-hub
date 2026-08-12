# GSE Agent Hub

> Model-agnostic standards for AI coding agents — write your roles, skills & workflows once,
> run them on Claude Code, Gemini CLI, or Codex. Flutter-first.

Central, reusable hub of AI-agent **roles**, **skills**, and **workflows** for software
development. **Currently focused on Flutter.** The shared assets (roles, workflows,
cross-stack skills) live at the top and are stack-agnostic; Flutter-specific manuals live
under its own folder. Only Flutter exists today — more stacks may be added later.

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

## Usage — how an agent picks up the hub
Each CLI auto-reads a different root file. `AGENTS.md` is the emerging universal standard
(Linux Foundation; read natively by Codex, Cursor, and Windsurf), but Claude Code and Gemini
CLI each need a small one-time nudge:

| Tool | Auto-reads by default | To use this hub |
|---|---|---|
| Codex · Cursor · Windsurf | `AGENTS.md` | Works out of the box. |
| Claude Code | `CLAUDE.md` | Keep the root `CLAUDE.md` bridge pointing to `AGENTS.md`. |
| Gemini CLI | `GEMINI.md` | Keep the root `GEMINI.md` bridge pointing to `AGENTS.md`. |

Both `CLAUDE.md` and `GEMINI.md` are one-line bridges to `AGENTS.md`, so Claude Code and
Gemini CLI pick up the hub out of the box — no per-user setup.

Only the **root file is auto-loaded** — it's the switch that turns on the rest. The deeper
files (`roles/`, `skills/`, `workflows/`) load **on demand**, when the bridge or your prompt
points to them.

### Two ways it kicks in
- **Ambient (automatic):** the auto-loaded root file makes the agent apply the conventions by
  default — you don't have to ask.
- **On-demand (you invoke):** point at a workflow or skill in your prompt, e.g.
  *"Follow `.agents/workflows/feature-dev.md` to add a login screen, per the Flutter conventions."*

### Quickstart (in your project)
1. Copy `.agents/` into your project root.
2. Keep the root bridge for your tool (see the table above).
3. Code as usual — conventions apply automatically; invoke a workflow when you want the full flow.

## Current stacks
> **Flutter only, for now.** The roles and workflows are already stack-agnostic, so more
> stacks may possibly be added in the future — but none are promised. Flutter is the only
> supported stack today.

- `flutter/` — Dart + Flutter, **GSE architecture** (Clean layer-first, BLoC, go_router, dio, get_it, design_system + gse_localization). Skills: architecture (scaffold), flavors, new-module/new-model/new-repository/new-bloc/new-screen, check-arch, clean-code, testing. Scaffolding via `architecture/generate.mjs` (no VSCode extension needed).
