"""Tests for the handoff envelope parser (deterministic routing depends on it)."""

from jerry.envelope import parse_envelope


def _wrap(body: str) -> str:
    return f"some prose from the model\n<<<ENVELOPE\n{body}\nENVELOPE>>>\ntrailing text"


def test_parses_a_valid_envelope():
    env = parse_envelope(
        _wrap("status: PASS\nnext_action: PROCEED\nblocking_items: \nsummary: done")
    )
    assert env.status == "PASS"
    assert env.next_action == "PROCEED"
    assert env.blocking_items == []
    assert env.summary == "done"


def test_loop_back_keeps_its_colon():
    env = parse_envelope(
        _wrap("status: CHANGES_REQUESTED\nnext_action: LOOP_BACK:implementer\n"
              "blocking_items: fix a; fix b\nsummary: two issues")
    )
    assert env.next_action == "LOOP_BACK:implementer"
    assert env.blocking_items == ["fix a", "fix b"]


def test_missing_envelope_defaults_to_escalation():
    # A model that ignores the protocol must not silently proceed.
    env = parse_envelope("I forgot to emit an envelope.")
    assert env.status == "FAIL"
    assert env.next_action == "ESCALATE:HUMAN"


def test_status_is_uppercased():
    env = parse_envelope(_wrap("status: pass\nnext_action: PROCEED"))
    assert env.status == "PASS"
