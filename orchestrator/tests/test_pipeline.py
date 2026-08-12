"""Tests for the pipeline engine, driven by the keyless mock adapter."""

from jerry.pipeline import resolve_nodes, run_feature


def _run():
    return run_feature("Add a login screen", provider="mock", verbose=False)


def test_happy_path_reaches_the_human_gate():
    result = _run()
    assert result.outcome == "HUMAN_GATE"


def test_roles_run_in_the_workflow_order_with_one_loop_back():
    result = _run()
    # reviewer bounces to implementer once, then the flow completes.
    assert result.roles == [
        "planner",
        "implementer",
        "reviewer",       # attempt 1 → CHANGES_REQUESTED
        "implementer",    # re-run after loop-back
        "reviewer",       # attempt 2 → PASS
        "tester",
        "security-reviewer",
        "documentarian",
    ]


def test_the_loop_back_is_a_real_retry():
    result = _run()
    reviewer_steps = [s for s in result.steps if s.role == "reviewer"]
    assert reviewer_steps[0].status == "CHANGES_REQUESTED"
    assert reviewer_steps[0].next_action == "LOOP_BACK:implementer"
    assert reviewer_steps[0].blocking_items  # non-empty
    assert reviewer_steps[1].status == "PASS"


def test_model_tiers_are_assigned_per_role():
    result = _run()
    by_role = {s.role: s.model for s in result.steps}
    assert by_role["planner"] == "mock-top"
    assert by_role["implementer"] == "mock-strong"
    assert by_role["tester"] == "mock-mid"
    assert by_role["documentarian"] == "mock-fast"


def test_prototype_profile_drops_the_heavy_stages():
    nodes = resolve_nodes("prototype")
    assert "security-reviewer" not in nodes
    assert "tester" not in nodes
    result = run_feature("quick spike", provider="mock", nodes=nodes, verbose=False)
    assert result.outcome == "HUMAN_GATE"
    # planner, implementer, reviewer(x2 after loop-back) — never a security step.
    assert "security-reviewer" not in result.roles


def test_skip_removes_specific_roles():
    nodes = resolve_nodes("full", skip=["tester", "documentarian"])
    assert "tester" not in nodes and "documentarian" not in nodes
    assert "planner" in nodes and "security-reviewer" in nodes
