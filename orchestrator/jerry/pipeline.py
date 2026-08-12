"""Phase 3: the full feature-dev pipeline.

Chains the roles in the order defined by .agents/workflows/feature-dev.md, passes the
handoff envelope between them, and *enforces* the retry caps and the human gate — the
guarantees that soft (model-driven) orchestration can't make.

    python -m jerry.pipeline --task "Add a login screen" --provider mock
    python -m jerry.pipeline --task "quick spike" --profile prototype

Which roles run is configurable (see PROFILES / --skip) so a throwaway project isn't
forced through the full six-stage pipeline. Routing stays deterministic: it keys off each
envelope's status / next_action, never off the free-form prose around it.
"""

import argparse
from dataclasses import dataclass, field

from .adapters import get_adapter
from .envelope import END, START, parse_envelope
from .models import PROVIDERS, model_for
from .roles import build_system_prompt

# Canonical node order from feature-dev.md (the human gate is the implicit final node).
NODES = ["planner", "implementer", "reviewer", "tester", "security-reviewer", "documentarian"]

# Named presets: pick the rigor that fits the work. "full" is the safe default.
PROFILES = {
    "full": NODES,                                          # everything
    "prototype": ["planner", "implementer", "reviewer"],    # skip test/security/docs
    "quick": ["planner", "implementer"],                    # just build it
    "plan-only": ["planner"],                               # only think it through
}

# Caps from feature-dev.md: max 2 retries per transition; a global backstop too.
MAX_LOOPBACKS_PER_ROLE = 2
MAX_TOTAL_LOOPBACKS = 6


@dataclass
class StepRecord:
    role: str
    model: str
    attempt: int
    status: str
    next_action: str
    blocking_items: list = field(default_factory=list)


@dataclass
class PipelineResult:
    steps: list = field(default_factory=list)
    outcome: str = ""      # HUMAN_GATE | ESCALATED_RETRY_CAP | ESCALATED_HUMAN | ...
    detail: str = ""

    @property
    def roles(self) -> list:
        return [s.role for s in self.steps]


def resolve_nodes(profile: str = "full", skip: list | None = None) -> list:
    """Turn a profile name + a skip list into the ordered list of roles to run."""
    base = PROFILES.get(profile, NODES)
    skipped = set(skip or [])
    return [n for n in base if n not in skipped]


def build_step_prompt(task: str, role: str, upstream_summary: str, attempt: int) -> str:
    """The per-step user prompt: context in, envelope required out."""
    return (
        "# STEP CONTEXT\n"
        f"role: {role}\n"
        f"attempt: {attempt}\n"
        f"feature: {task}\n"
        f"upstream_summary: {upstream_summary}\n\n"
        "# YOUR TASK\n"
        "Perform your role for this feature, following the standards in your system prompt.\n\n"
        "# OUTPUT PROTOCOL\n"
        "End your reply with a handoff envelope, exactly in this format:\n"
        f"{START}\n"
        "status: PASS | CHANGES_REQUESTED | FAIL | BLOCKED | CLEAN\n"
        "next_action: PROCEED | LOOP_BACK:<role> | ESCALATE:HUMAN\n"
        "blocking_items: <semicolon-separated; empty if none>\n"
        "summary: <=500 tokens; reference files/steps, don't re-paste context\n"
        f"{END}\n"
    )


def run_feature(
    task: str, provider: str, nodes: list | None = None, verbose: bool = True
) -> PipelineResult:
    nodes = nodes or NODES
    adapter = get_adapter(provider)
    result = PipelineResult()
    runs: dict[str, int] = {}       # executions per role -> attempt number
    loopbacks: dict[str, int] = {}  # loop-backs emitted per role -> retry cap
    total_loopbacks = 0
    upstream_summary = f"Feature request: {task}"

    def say(msg: str) -> None:
        if verbose:
            print(msg)

    say(f"\n=== JERRY pipeline · provider={provider} ===")
    say(f"Feature: {task}")
    say(f"Roles: {' → '.join(nodes)}")
    if "security-reviewer" not in nodes:
        say("⚠  security-reviewer is OFF — ok for a throwaway prototype, not for anything you ship.")
    say("")

    i = 0
    while i < len(nodes):
        role = nodes[i]
        runs[role] = runs.get(role, 0) + 1
        attempt = runs[role]

        model = model_for(provider, role)
        system = build_system_prompt(role)
        prompt = build_step_prompt(task, role, upstream_summary, attempt)
        env = parse_envelope(adapter.complete(system, prompt, model))

        result.steps.append(
            StepRecord(role, model, attempt, env.status, env.next_action, env.blocking_items)
        )
        head = f"▸ {role:<17} {model:<24} attempt {attempt}"
        say(f"{head} → {env.status} / {env.next_action}")
        for item in env.blocking_items:
            say(f"    - {item}")

        if env.next_action == "PROCEED":
            upstream_summary = env.summary
            i += 1

        elif env.next_action.startswith("LOOP_BACK:"):
            target = env.next_action.split(":", 1)[1].strip()
            loopbacks[role] = loopbacks.get(role, 0) + 1
            total_loopbacks += 1
            if loopbacks[role] > MAX_LOOPBACKS_PER_ROLE or total_loopbacks > MAX_TOTAL_LOOPBACKS:
                result.outcome = "ESCALATED_RETRY_CAP"
                result.detail = f"{role} hit the retry cap."
                say(f"\n⏹ ESCALATE → HUMAN: {result.detail} Stopping.")
                return result
            if target not in nodes:
                result.outcome = "ESCALATED_UNKNOWN_TARGET"
                result.detail = f"loop-back target {target!r} is not an active role"
                say(f"\n⏹ ESCALATE → HUMAN: {result.detail}.")
                return result
            upstream_summary = "Changes requested: " + "; ".join(env.blocking_items)
            i = nodes.index(target)

        elif env.next_action == "ESCALATE:HUMAN":
            result.outcome = "ESCALATED_HUMAN"
            result.detail = env.summary
            say(f"\n⏸ HUMAN GATE: {role} escalated. summary: {env.summary}")
            return result

        else:
            result.outcome = "ESCALATED_UNROUTABLE"
            result.detail = f"cannot route (next_action={env.next_action!r})"
            say(f"\n⏹ ESCALATE → HUMAN: {result.detail}.")
            return result

    result.outcome = "HUMAN_GATE"
    say("\n⏸ HUMAN GATE — all active nodes passed.")
    say("  Human reviews the full diff and owns all git operations (agents never touch git).")
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the feature-dev pipeline.")
    parser.add_argument("--task", required=True, help="the feature to build")
    parser.add_argument(
        "--provider",
        default="mock",
        choices=PROVIDERS,
        help="provider: mock | anthropic | google (API) | claude-code | codex | gemini-cli (harness)",
    )
    parser.add_argument(
        "--profile",
        default="full",
        choices=list(PROFILES),
        help="how much rigor to run (default: full)",
    )
    parser.add_argument(
        "--skip",
        default="",
        help="comma-separated roles to drop, e.g. tester,documentarian",
    )
    args = parser.parse_args()

    skip = [s.strip() for s in args.skip.split(",") if s.strip()]
    nodes = resolve_nodes(args.profile, skip)
    run_feature(args.task, args.provider, nodes=nodes)


if __name__ == "__main__":
    main()
