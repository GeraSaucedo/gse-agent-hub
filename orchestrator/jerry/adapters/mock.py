"""A keyless adapter for testing the orchestrator without any provider.

Returns deterministic, envelope-formatted text so the full pipeline (role chaining,
envelope routing, retries, gates) can be exercised offline. It reads the `role` and
`attempt` from the step context in the prompt to script one realistic loop-back:
the reviewer requests changes on attempt 1, then passes on attempt 2.

NOT a demo of a real model — it's a test double.
"""

import re

from ..envelope import END, START
from .base import ModelAdapter


class MockAdapter(ModelAdapter):
    name = "mock"

    def complete(self, system: str, prompt: str, model: str) -> str:
        role = self._field(prompt, "role") or "unknown"
        attempt = int(self._field(prompt, "attempt") or "1")
        status, next_action, blocking, summary = self._decide(role, attempt)
        return (
            f"[mock:{model}] acting as {role} (attempt {attempt}).\n"
            f"{START}\n"
            f"status: {status}\n"
            f"next_action: {next_action}\n"
            f"blocking_items: {'; '.join(blocking)}\n"
            f"summary: {summary}\n"
            f"{END}\n"
        )

    @staticmethod
    def _field(text: str, key: str) -> str | None:
        m = re.search(rf"^{key}:\s*(.+)$", text, re.MULTILINE)
        return m.group(1).strip() if m else None

    @staticmethod
    def _decide(role: str, attempt: int):
        if role == "reviewer" and attempt == 1:
            return (
                "CHANGES_REQUESTED",
                "LOOP_BACK:implementer",
                [
                    "Extract the login form into its own widget",
                    "Handle the empty-password edge case",
                ],
                "Two issues found; sending back to implementer.",
            )
        if role == "security-reviewer":
            return ("CLEAN", "PROCEED", [], "No security issues in scope.")
        return ("PASS", "PROCEED", [], f"{role} completed successfully.")
