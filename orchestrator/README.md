# JERRY Orchestrator

A thin, **model-agnostic** runner for the hub. It reads the same `roles/`, `skills/`, and
`workflows/` a human or a coding harness would read, and dispatches each role to a model
through a swappable adapter — so the *same standards* run on Claude, Gemini, or any provider
you add. Swap the model, keep the instructions.

> The hub already works today via "soft" orchestration (Claude Code / Gemini CLI read the
> assets and follow them). This orchestrator is the "hard" path: **code that guarantees the
> flow** — order, retries, and human gates — instead of relying on the model to remember them.

## Architecture (the seam)

```
run.py / pipeline  ─▶  ModelAdapter.complete(system, prompt, model)
                              │  one interface, provider-agnostic
        ┌─────────────────────┼─────────────────────────┐
        ▼                     ▼                          ▼
   MockAdapter          LiteLLMAdapter            HarnessAdapter
   (canned, no key)     RAW MODEL — no hands      HAS HANDS — edits files
        │                     │                          │
        │            ┌────────┼───────┐        ┌─────────┼─────────┐
        ▼            ▼        ▼        ▼        ▼         ▼         ▼
     testing    Anthropic  Google  100+ more  Claude    Codex   Gemini
                                               Code               CLI
```

The orchestrator never imports a provider SDK or CLI directly — only `ModelAdapter`. That
single seam ([jerry/adapters/base.py](jerry/adapters/base.py)) is what makes the hub
model-agnostic. Two families sit behind it:

- **Raw model (no hands):** `LiteLLMAdapter` → the model as text-in/text-out. Great for the
  coordination logic, but it can't touch your files.
- **Harness (has hands):** `HarnessAdapter` → drives a coding CLI (Claude Code, Codex, Gemini
  CLI) that reads/writes files and runs commands. **This is what actually builds an app.**
  File changes land on disk; `complete()` returns the CLI's stdout with the envelope.

## Layout
| File | What it does |
|---|---|
| `jerry/adapters/base.py` | The `ModelAdapter` interface (the model-agnostic seam) |
| `jerry/adapters/mock.py` | Keyless test double — run the pipeline offline |
| `jerry/adapters/litellm_adapter.py` | Raw model (no hands), via LiteLLM (lazy) |
| `jerry/adapters/harnesses.py` | Harness adapters (hands): Claude Code, Codex, Gemini CLI |
| `jerry/models.py` | role → reasoning tier → concrete model id, per provider |
| `jerry/roles.py` | reads `AGENTS.md` + `roles/<role>.md` → a system prompt |
| `jerry/envelope.py` | the handoff envelope + parser (deterministic routing) |
| `jerry/run.py` | Phase 1 CLI: run one role against one model |
| `jerry/pipeline.py` | Phase 3 CLI: the full feature-dev pipeline |

## Run it (no API key needed)

From the `orchestrator/` directory:

```bash
python -m jerry.run --role planner --task "Add a login screen" --provider mock
```

The `mock` provider returns canned text, so this works with zero dependencies and no keys —
it proves the wiring: hub asset → system prompt → adapter → response.

### The full pipeline

```bash
python -m jerry.pipeline --task "Add a login screen" --provider mock
```

Chains all six roles per `workflows/feature-dev.md`, passing the handoff envelope between
them. The mock scripts one realistic loop-back (reviewer → implementer → reviewer) so you
can see the enforced retry and the human gate without any API key.

## Run it for real (later)

```bash
pip install litellm

export ANTHROPIC_API_KEY=...      # for --provider anthropic
export GEMINI_API_KEY=...         # for --provider google

python -m jerry.pipeline --task "Add a login screen" --provider anthropic
python -m jerry.pipeline --task "Add a login screen" --provider google
```

Same roles, same standards — only `--provider` changes. That is the whole point.
LiteLLM reads the API key from the standard env var for each provider.

### Run it with a harness (this actually edits files)

The `--provider claude-code | codex | gemini-cli` options drive a coding CLI that has
hands — it reads/writes files and runs commands in your project.

```bash
export JERRY_PROJECT_DIR=/path/to/your/flutter/app   # where the harness should act

python -m jerry.pipeline --task "Add a login screen" --provider claude-code
```

Caveats before a real run:
- The CLI must be installed and authenticated (`claude`, `codex`, `gemini`).
- Verify the argv/flags in `jerry/adapters/harnesses.py` against each CLI's `--help`.
- For **autonomous** edits you must add each CLI's approval/permission flag (left out on
  purpose — non-interactive file writes are a deliberate, per-environment choice).

## Roadmap
- **Phase 1 (done):** adapter seam + role loader + single-role run.
- **Phase 3 (done):** the full pipeline — chains roles per `workflows/feature-dev.md`, passes
  the handoff envelope between them, enforces retry caps and the human gate.
- **Next:** packaging (`pyproject.toml`) + a `pytest` suite over the mock pipeline; then wire a
  real provider live and diff the same feature across Claude vs Gemini.
