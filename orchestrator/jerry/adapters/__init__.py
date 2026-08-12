"""Adapter factory: pick a provider by name.

Two families of adapters:
  - RAW MODEL (no hands): "mock" (keyless test) and LiteLLM ("anthropic", "google", ...).
    Good for coordination logic; can't touch your files.
  - HARNESS (has hands): "claude-code", "codex", "gemini-cli" drive a coding CLI that
    reads/writes files and runs commands. This is what actually builds an app.

Imports are lazy so choosing "mock" never requires litellm, and choosing a raw-model
provider never requires a harness CLI to be installed.
"""

from .base import ModelAdapter


def get_adapter(provider: str) -> ModelAdapter:
    if provider == "mock":
        from .mock import MockAdapter

        return MockAdapter()

    if provider in ("anthropic", "google"):
        from .litellm_adapter import LiteLLMAdapter

        return LiteLLMAdapter()

    if provider == "claude-code":
        from .harnesses import ClaudeCodeAdapter

        return ClaudeCodeAdapter()

    if provider == "codex":
        from .harnesses import CodexAdapter

        return CodexAdapter()

    if provider == "gemini-cli":
        from .harnesses import GeminiCLIAdapter

        return GeminiCLIAdapter()

    raise ValueError(f"Unknown provider: {provider!r}")
