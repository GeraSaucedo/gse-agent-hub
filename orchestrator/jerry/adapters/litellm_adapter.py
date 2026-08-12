"""One adapter for every real provider, via LiteLLM.

LiteLLM exposes a single `completion()` call that translates to 100+ backends
(Anthropic, Google, OpenAI, Bedrock, Ollama, ...). The concrete model id — with its
provider prefix — comes from models.py, e.g. "anthropic/claude-opus-4-8" or
"gemini/gemini-2.5-pro". API keys are read from the standard provider env vars by
LiteLLM itself (e.g. ANTHROPIC_API_KEY, GEMINI_API_KEY).
"""

from .base import ModelAdapter


class LiteLLMAdapter(ModelAdapter):
    name = "litellm"

    def __init__(self) -> None:
        try:
            import litellm
        except ImportError as e:
            raise RuntimeError(
                "The 'litellm' package is not installed. Run: pip install litellm"
            ) from e
        self._litellm = litellm

    def complete(self, system: str, prompt: str, model: str) -> str:
        resp = self._litellm.completion(
            model=model,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": prompt},
            ],
        )
        return resp.choices[0].message.content or ""
