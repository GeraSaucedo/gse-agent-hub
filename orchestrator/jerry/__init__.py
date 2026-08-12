"""JERRY orchestrator: run the hub's roles/workflows against any model.

Model-agnostic by design — the orchestrator talks to a single ModelAdapter
interface, never to a provider SDK directly. Swap the adapter, keep the standards.
"""
