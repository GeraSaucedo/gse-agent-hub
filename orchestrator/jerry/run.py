"""Phase 1 entry point: run ONE role against ONE model.

    python -m jerry.run --role planner --task "Add login" --provider mock

This proves the core seam end to end: load a role from the hub, build its system
prompt, and dispatch it through a swappable adapter. Swap --provider to change the
model with zero changes to the role or the prompt.
"""

import argparse

from .adapters import get_adapter
from .models import PROVIDERS, model_for
from .roles import available_roles, build_system_prompt


def main() -> None:
    parser = argparse.ArgumentParser(description="Run one JERRY role against one model.")
    parser.add_argument("--role", required=True, help=f"one of: {', '.join(available_roles())}")
    parser.add_argument("--task", required=True, help="the task/description for the role")
    parser.add_argument(
        "--provider",
        default="mock",
        choices=PROVIDERS,
        help="which provider to use (default: mock, no API key needed)",
    )
    args = parser.parse_args()

    system = build_system_prompt(args.role)
    adapter = get_adapter(args.provider)
    model = model_for(args.provider, args.role)

    print(f"→ role={args.role}  provider={args.provider}  model={model}\n")
    print(adapter.complete(system=system, prompt=args.task, model=model))


if __name__ == "__main__":
    main()
