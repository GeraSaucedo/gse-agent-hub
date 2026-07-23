# Workflow: Feature development

The default flow for building one feature. Start as a **loop**; escalate to the
**graph** branches only when a step fails repeatedly.

## Nodes (roles)
Planner → Implementer → Reviewer → Tester → Security Reviewer → Documentarian → Human gate

## Flow (happy path)
1. **Plan** (Planner) → produces numbered plan + open questions.
   - Gate: if open questions exist, ask the human before continuing.
2. For each plan step, run this inner loop:
   1. **Implement** (Implementer) → code + tests for the step.
   2. **Review** (Reviewer) → approve or request changes.
   3. **Test** (Tester) → run suite, capture results.
3. **Security review** (Security Reviewer) — **mandatory on every change**. Critical/high findings loop back to Implementer before continuing.
   - Reviewer and Security Reviewer are both **read-only** analyses of the same diff, so they may **run concurrently**; merge their `blocking_items` before any single loop-back to the Implementer. Run the Tester on the diff once it has passed review.
4. **Document** (Documentarian) — record the decisions, trade-offs, and notes from this change in the project's `docs/worklog/`, dated by session.
5. **Human gate** → human reviews the full change, then handles all version control themselves (agents never touch git).

## Handoff envelope (every arrow)
Each handoff carries a small, machine-checkable header so routing is deterministic — not free-form chatter:
```
from → to · step_id
status:      PASS | CHANGES_REQUESTED | FAIL | BLOCKED | CLEAN
next_action: PROCEED | LOOP_BACK:<role> | ESCALATE:HUMAN
blocking_items: [ … ]   # empty unless CHANGES_REQUESTED / FAIL; role-specific payload below
summary:     ≤ ~500 tokens; reference file paths / step IDs, don't re-paste prior context
```
Routing keys off `status`/`next_action`; the payload each arrow carries:
- **Planner → Implementer:** numbered plan (per step: change, file(s), verification), key decisions + why, open questions.
- **Implementer → Reviewer:** the diff, which plan step it satisfies, commands run + results.
- **Reviewer → Tester:** verdict + any accepted follow-ups (reviewer never rewrites code).
- **Tester → Security Reviewer:** results report (command, pass/fail, failure output) + per-failure diagnosis.
- **Security Reviewer → Documentarian:** findings by severity (file+line, risk, fix), or "clean in scope".
- **Documentarian → Human gate:** the dated `docs/worklog/` session entry for this change.

## Separation of concerns
- Only the **Planner** and the **Human gate** talk to the human. Other roles are internal to the pipeline.
- Downstream roles do **not** re-litigate requirements. If one hits a requirements question, it stops and routes back to the Planner — it does not reinterpret the goal mid-task.

## Retries & branching (the graph part)
- Reviewer requests changes → back to Implementer. **Max 2 retries per step.**
- Tests fail → back to Implementer with the failure output. **Max 2 retries.**
- Besides the per-transition caps, cap **total inner-loop iterations per plan step** (e.g. 3; security critical/high loop-backs count too).
- After max retries on a step → **stop the loop**, summarize the blocker, escalate to human.
- Plan turns out wrong mid-implementation → back to Planner (re-plan the remaining steps only).

## Human approval gates (never automatic)
- **All version control.** Agents never run git; the human commits/pushes after review.
- Deploys.
- Deleting or overwriting files the agent didn't create.
- Adding a new dependency.

## Done criteria
- All plan steps implemented, reviewed, and tested green.
- Human has approved the final diff.

## When to keep it a simple loop vs. graph
- **Loop** (default): single, well-scoped feature, one stack, human reviews at the end.
- **Graph**: multiple specialized agents coordinating, branching logic, or state that
  must persist across sessions. Move here only when real failures justify it.

## Scale the process to the change (KISS)
For a trivial change, one agent may wear several role hats in a single pass instead of
running six separate stages — but the Security review and Human gate are never skipped.
Don't spin up the full pipeline for a one-line fix.
