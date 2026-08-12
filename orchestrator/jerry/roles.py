"""Assemble a role's system prompt from the hub's Markdown assets.

The hub is the single source of truth: this just reads the same files a human or a
harness would read — the global standards (AGENTS.md) plus the role definition.
"""

from pathlib import Path

# roles.py -> jerry/ -> orchestrator/ -> repo root
REPO_ROOT = Path(__file__).resolve().parents[2]
ROLES_DIR = REPO_ROOT / ".agents" / "roles"
GLOBAL_STANDARDS = REPO_ROOT / "AGENTS.md"


def available_roles() -> list[str]:
    return sorted(p.stem for p in ROLES_DIR.glob("*.md"))


def load_role(role: str) -> str:
    """Read a single role definition, e.g. 'planner' -> roles/planner.md."""
    path = ROLES_DIR / f"{role}.md"
    if not path.exists():
        raise FileNotFoundError(
            f"No role '{role}'. Available: {', '.join(available_roles())}"
        )
    return path.read_text(encoding="utf-8")


def build_system_prompt(role: str) -> str:
    """Global standards + the role definition = the role's system prompt.

    (Stack conventions and skills get layered in later, in the pipeline phase.)
    """
    standards = GLOBAL_STANDARDS.read_text(encoding="utf-8")
    role_def = load_role(role)
    return f"{standards}\n\n---\n\n{role_def}"
