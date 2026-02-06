<!--
  Wrapped Spec Kit file: .specify/specs/CLAUDE.md
  Migrated from CLAUDE.md — content preserved.
-->

# Feature Specification: CLAUDE — System Instructions

**Feature Branch**: `[migration/specs-into-spec-kit]`
**Created**: 2026-02-06
**Status**: Canonical (migrated)

```markdown
<!--
  CLAUDE.md
  Repository system instructions (Context Engineering) for Project Chimera.
  Use this file as the authoritative runtime/system prompt for assistant behavior in this repo.
  Referenced specs: `.specify/specs/_meta.md`, `.specify/specs/functional.md`, `.specify/specs/technical.md`
-->

# Project Chimera — System Instructions

Identity
--------
This is Project Chimera, an autonomous influencer network.

Prime Directive
---------------
NEVER generate code without checking `.specify/specs/_meta.md`, `.specify/specs/functional.md`, and `.specify/specs/technical.md` first.

Workflow Requirements
---------------------
- Always explain the architectural rationale before providing code snippets or implementation suggestions.
- When producing code, reference the exact sections and policy hashes from the specification files that justify the chosen design.

Governance
----------
- Enforce the Neuro‑Symbolic‑Causal (NSC) framework: neural reasoning (LLMs) MUST be combined with a deterministic Symbolic Guardian and a bounded Causal Oracle for decision approval.
- All external tool interactions and I/O MUST be mediated via the Model Context Protocol (MCP). Direct third-party API calls from agent runtimes are prohibited.

Technology Standards
--------------------
- Runtime: Python 3.12 (use `uvicorn`/`uvloop` for async services where appropriate).
- Protocols: MCP for all Resources and Tools; MCP Servers must publish capability manifests and conformance hashes.
- Commerce: All agentic commerce flows MUST use Coinbase AgentKit via an approved `mcp-server-coinbase` wrapper and follow HITL cryptographic signature requirements.

Safety & Operational Rules
-------------------------
- Never expose secrets, private keys, or direct access to internal GlobalState. Wallet operations must only be performed through the sanctioned Coinbase AgentKit MCP Server and gated by the CFO and the Symbolic Guardian.
- All policy changes, persona updates (SOUL.md), and MCP Server registrations require change-control, conformance testing, and an auditable migration record as described in `.specify/specs/_meta.md`.

Communication & Evidence
-----------------------
- All external-facing actions (MCP Tool calls, PoI exchanges, transactions) must generate Evidence Packets and DecisionRecords that include policy_hash, state_version, timestamps, and signatures where applicable.
- Evidence artifacts must be stored in the immutable audit ledger and be exportable for legal or compliance review.

Behavioral Constraints for Assistants
------------------------------------
- Before offering code: cite the specification sections (file and short path) that govern the change.
- Prefer conservative-fail defaults: if a design choice could violate policy, require human approval (HITL) and declare the specific constraint preventing automation.
- If the user asks to bypass governance (e.g., disable Symbolic Guardian, expose private keys), refuse and provide the compliant alternative.

Amendments
----------
Updates to these instructions must include a commit referencing `ARCH-META-CHANGE: <summary>` and must link to the relevant spec updates in `.specify/specs/`.

-- End of CLAUDE.md
```
