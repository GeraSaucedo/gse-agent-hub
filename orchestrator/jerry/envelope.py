"""The handoff envelope — the machine-checkable header every role emits.

Mirrors the "Handoff envelope" contract in .agents/workflows/feature-dev.md so
routing is deterministic instead of free-form chatter. The orchestrator routes on
`status` / `next_action`; everything else is payload.
"""

from dataclasses import dataclass, field

VALID_STATUS = {"PASS", "CHANGES_REQUESTED", "FAIL", "BLOCKED", "CLEAN"}

START = "<<<ENVELOPE"
END = "ENVELOPE>>>"


@dataclass
class Envelope:
    # Safe defaults: if a model returns garbage, we escalate to a human rather
    # than silently proceeding.
    status: str = "FAIL"
    next_action: str = "ESCALATE:HUMAN"
    blocking_items: list = field(default_factory=list)
    summary: str = ""
    raw: str = ""


def parse_envelope(text: str) -> Envelope:
    """Extract the envelope block from a model's reply. Forgiving by design."""
    if START not in text or END not in text:
        return Envelope(summary="No envelope block found in model output.", raw=text)

    block = text.split(START, 1)[1].split(END, 1)[0]

    fields: dict[str, str] = {}
    for line in block.splitlines():
        if ":" in line:
            key, value = line.split(":", 1)  # split once — LOOP_BACK:<role> keeps its colon
            fields[key.strip().lower()] = value.strip()

    raw_blocking = fields.get("blocking_items", "")
    blocking: list[str] = []
    if raw_blocking and raw_blocking not in ("[]", "none", "-"):
        blocking = [b.strip() for b in raw_blocking.split(";") if b.strip()]

    return Envelope(
        status=fields.get("status", "FAIL").upper(),
        next_action=fields.get("next_action", "ESCALATE:HUMAN").strip(),
        blocking_items=blocking,
        summary=fields.get("summary", ""),
        raw=text,
    )
