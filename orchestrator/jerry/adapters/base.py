"""The model-agnostic seam.

Every provider (Claude, Gemini, GPT, ...) is wrapped by a subclass of ModelAdapter.
The orchestrator only ever calls `complete()` — it has no idea which provider is
behind it. This is what lets the same roles/skills/workflows run on any model.
"""

from abc import ABC, abstractmethod


class ModelAdapter(ABC):
    """One method, one job: turn (system prompt + user prompt) into text."""

    #: short provider id, e.g. "anthropic" | "google" | "mock"
    name: str = "base"

    @abstractmethod
    def complete(self, system: str, prompt: str, model: str) -> str:
        """Send one request to the model and return its text response.

        Args:
            system: the role's system prompt (standards + role definition).
            prompt: the concrete task / handoff payload for this step.
            model:  the concrete model id for this provider (see models.py).

        Returns:
            The model's reply as plain text.
        """
        raise NotImplementedError
