"""Map a role -> a reasoning tier -> a concrete model id per provider.

The tiers come from the hub README's "Model per role" table: match model power to
the reasoning the role needs, don't run the top model for everything.

NOTE: model ids change over time. Verify them against each provider's current docs
before running for real — this file is the single place to update them.
"""

# role name (matches .agents/roles/<name>.md) -> tier
ROLE_TIERS = {
    "planner": "top",
    "security-reviewer": "top",
    "reviewer": "strong",
    "implementer": "strong",
    "tester": "mid",
    "documentarian": "fast",
}

# provider -> tier -> concrete model id, in LiteLLM's "<provider>/<model>" format.
# Adding a new provider is just another entry here — the LiteLLM adapter handles the
# rest. Verify ids against each provider's current docs before real runs.
TIER_MODELS = {
    "anthropic": {
        "top": "anthropic/claude-opus-4-8",
        "strong": "anthropic/claude-sonnet-4-6",
        "mid": "anthropic/claude-sonnet-4-6",
        "fast": "anthropic/claude-haiku-4-5-20251001",
    },
    "google": {
        "top": "gemini/gemini-2.5-pro",
        "strong": "gemini/gemini-2.5-flash",
        "mid": "gemini/gemini-2.5-flash",
        "fast": "gemini/gemini-2.5-flash-lite",
    },
    # Harness (CLI) providers take BARE model ids, not LiteLLM-prefixed ones.
    "claude-code": {
        "top": "claude-opus-4-8",
        "strong": "claude-sonnet-4-6",
        "mid": "claude-sonnet-4-6",
        "fast": "claude-haiku-4-5-20251001",
    },
    "gemini-cli": {
        "top": "gemini-2.5-pro",
        "strong": "gemini-2.5-flash",
        "mid": "gemini-2.5-flash",
        "fast": "gemini-2.5-flash-lite",
    },
    # Codex model ids are uncertain here; "" means "let the CLI use its configured
    # default" (the adapter omits the --model flag). Fill these in to pin a model.
    "codex": {"top": "", "strong": "", "mid": "", "fast": ""},
}

# Every provider the orchestrator understands (raw-model + harness).
PROVIDERS = ["mock", "anthropic", "google", "claude-code", "codex", "gemini-cli"]


def model_for(provider: str, role: str) -> str:
    """Return the concrete model id for a (provider, role) pair.

    The mock provider has no real models, so it just echoes a label.
    """
    if provider == "mock":
        return f"mock-{ROLE_TIERS.get(role, 'strong')}"

    tier = ROLE_TIERS.get(role, "strong")
    try:
        return TIER_MODELS[provider][tier]
    except KeyError as e:
        raise ValueError(f"No model mapping for provider={provider!r} tier={tier!r}") from e
