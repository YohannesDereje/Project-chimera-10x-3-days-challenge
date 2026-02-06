<!--
  specs/_meta.md
  Project Chimera canonical specification meta.
  This file mirrors .specify/specs/_meta.md for rubric alignment.
-->

Project Chimera — Specification Meta (Source of Truth)
Version: 2026-02-05

Status: Definitive Source of Truth

1. Purpose
This document is the canonical specification meta for the Project Chimera Core Architecture. It defines the vision, architectural mandates, governance controls, standardization requirements, and financial guardrails necessary to transition from static content scripts to production-grade Autonomous Influencer Agents with perception and verifiable economic agency.

2. Scope
Applies to all components, services, MCP Servers, agent runtimes, orchestration layers, governance tooling, and operator processes within Project Chimera. All downstream implementations and integrations SHALL conform to the mandates in this document.

3. Principles (Source-of-Truth Obligations)
Authoritative: This file supersedes ad-hoc design notes and is the single point of truth for System Design and Governance.

Traceable: Every requirement here must link to a testable acceptance criterion, an audit trail, and an owning role.

Conservative-Fail: Autonomous actions must prefer safety and reversibility over expediency.

4. Vision
Project Chimera transitions the product from static content scripts to a fleet of Autonomous Influencer Agents that possess:

Persistent Perception: Continuous, MCP-mediated ingestion of world state.

Neuro-Symbolic-Causal Cognition: Integrated neural reasoning with symbolic rules and causal simulation for robust decision-making.

Economic Agency: Non-custodial on-chain wallets via Coinbase AgentKit enabling provable, auditable commerce.

All agent behaviors shall be provably bounded by rule-based overrides and human oversight.

5. Architecture Mandate — Neuro‑Symbolic‑Causal Framework
Mandate: Project Chimera SHALL implement the Neuro-Symbolic-Causal (NSC) architecture as the canonical cognitive substrate for every production agent.

5.1 Components and Responsibilities
Neural Layer (Neuro): Large Language Models (LLMs) providing pattern recognition, creative reasoning, and high-dimensional perception.

Symbolic Layer (Symbolic): Deterministic logic, rule engines, and enforceable invariants. This layer MUST encode all hard constraints (safety, legal, financial caps).

Causal Layer (Causal): A lightweight causal simulator used by the Planner and the Symbolic Guardian to evaluate downstream impacts of candidate actions before execution.

5.2 Design Constraints
Final approval for any state-changing operation is subject to the Judge + Symbolic Guardian + Causal checks.

No LLM output alone shall be treated as normatively binding.

Persona Persistence: Every agent's creative output must be gated by a SOUL.md schema to prevent "tonal drift."

6. Governance — The Symbolic Guardian
Definition: The Symbolic Guardian is the immutable logic layer that enforces hard invariants and provides machine-verifiable justification for every external action.

6.1 Core Capabilities
Policy Enforcement: Maintain an auditable PolicyStore including brand rules and budget caps.

Rule Evaluation Engine: Deterministically evaluate candidate actions (Approve, Reject, or Escalate).

Override Authority: The Symbolic Guardian's decision SHALL be authoritative over LLM suggestions.

Multi-Tenant Isolation: The Guardian MUST enforce strict cryptographic silos between agent identities.

6.2 Operational Rules
The Symbolic Guardian SHALL be implemented as an explicit service separate from the LLM runtime.

Any modification to the PolicyStore requires formal change-control.

7. Standardization — Model Context Protocol (MCP)
Mandate: All external world interactions MUST occur exclusively via MCP servers. Direct, ad-hoc third-party API calls are strictly prohibited.

7.1 Requirements
MCP-only I/O: Agent runtimes SHALL only bind to MCP Hosts/Servers.

OpenClaw Status Heartbeat: All agents MUST broadcast a periodic "Governance Heartbeat" to the OpenClaw network, including a health status of the Symbolic Guardian.

Auditing: All MCP Tool invocations SHALL be immutably logged.

8. Financial Guardrails — Coinbase AgentKit & HITL
Mandate: All commerce and wallet operations SHALL use Coinbase AgentKit.

8.1 Transaction Policy
Coinbase AgentKit Only: All monetary actions SHALL be executed via a validated mcp-server-coinbase wrapper.

HITL Cryptographic Signature: Any transaction involving value transfer SHALL require an HSM-backed human cryptographic signature prior to broadcast.

Multi-Party Escalation: High-risk thresholds require N-of-M approver signatures.

9. Compliance, Auditing, and Change Control
Immutable Audit Ledger: All external-facing actions produce an append-only audit record.

Evidence Packets: For every action, the system SHALL assemble a signed packet containing inputs, outputs, and Guardian decisions.

Fail-Safe Defaults: In the event of Guardian failure, the system mode SHALL be safe/halted.

10. Amendments
Any amendment must include the following metadata in the commit message: ARCH-META-CHANGE: <summary>.

-- End of Specification Meta --
