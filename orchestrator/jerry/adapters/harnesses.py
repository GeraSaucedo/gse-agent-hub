"""Adapters that drive an agentic coding CLI (a harness) as a subprocess.

The key difference vs. LiteLLMAdapter: a harness HAS HANDS. LiteLLM gives you the raw
model (text in, text out). A harness — Claude Code, Codex, Gemini CLI — reads and writes
files and runs commands in a working directory. So when the orchestrator dispatches a role
through one of these, the file changes happen on disk as a side effect, and complete()
returns the CLI's stdout (which should carry the handoff envelope for routing).

This is what turns the orchestrator from a "director without musicians" into one that
actually builds. And because it's just another ModelAdapter, the pipeline is unchanged.

IMPORTANT: CLI flags evolve. Verify each argv against `<cli> --help` before real runs.
For autonomous file edits you will likely also need an approval/permission flag (e.g.
Claude Code's --permission-mode, Codex's --full-auto, Gemini's --yolo). Those are left out
on purpose — enabling non-interactive edits is a deliberate, per-environment choice.
"""

import os
import shutil
import subprocess

from .base import ModelAdapter

# Where the harness should act. Set JERRY_PROJECT_DIR to your Flutter project, or the
# process working directory is used.
WORKDIR_ENV = "JERRY_PROJECT_DIR"


class HarnessAdapter(ModelAdapter):
    """Base: run a coding CLI in a working directory and return its stdout."""

    binary = ""            # the CLI executable, e.g. "claude"

    def __init__(self, workdir: str | None = None, timeout: int = 600) -> None:
        self.workdir = workdir or os.environ.get(WORKDIR_ENV) or os.getcwd()
        self.timeout = timeout
        if not shutil.which(self.binary):
            raise RuntimeError(
                f"'{self.binary}' CLI not found on PATH. Install it (or fix PATH) to use "
                f"the {self.name!r} provider."
            )

    def build_argv(self, prompt: str, model: str) -> list[str]:
        raise NotImplementedError

    def complete(self, system: str, prompt: str, model: str) -> str:
        full_prompt = f"{system}\n\n---\n\n{prompt}"
        argv = self.build_argv(full_prompt, model)
        try:
            proc = subprocess.run(
                argv,
                cwd=self.workdir,
                capture_output=True,
                text=True,
                timeout=self.timeout,
            )
        except subprocess.TimeoutExpired as e:
            raise RuntimeError(f"{self.binary} timed out after {self.timeout}s") from e
        if proc.returncode != 0:
            raise RuntimeError(
                f"{self.binary} exited {proc.returncode}: {proc.stderr.strip()[:500]}"
            )
        return proc.stdout


class ClaudeCodeAdapter(HarnessAdapter):
    name = "claude-code"
    binary = "claude"

    def build_argv(self, prompt: str, model: str) -> list[str]:
        # `-p` = headless/print mode. Verify with `claude --help`.
        argv = [self.binary, "-p"]
        if model:
            argv += ["--model", model]
        argv.append(prompt)
        return argv


class CodexAdapter(HarnessAdapter):
    name = "codex"
    binary = "codex"

    def build_argv(self, prompt: str, model: str) -> list[str]:
        # `exec` = non-interactive run. Verify with `codex exec --help`.
        argv = [self.binary, "exec"]
        if model:
            argv += ["--model", model]
        argv.append(prompt)
        return argv


class GeminiCLIAdapter(HarnessAdapter):
    name = "gemini-cli"
    binary = "gemini"

    def build_argv(self, prompt: str, model: str) -> list[str]:
        # `-p` takes the prompt as its value for non-interactive use. Verify with `gemini --help`.
        argv = [self.binary]
        if model:
            argv += ["-m", model]
        argv += ["-p", prompt]
        return argv
