<!--
  Wrapped Spec Kit file: .specify/specs/functional.md
  Migrated from specs/functional.md — content preserved.
-->

# Feature Specification: Functional — Swarm Architecture

**Feature Branch**: `[migration/specs-into-spec-kit]`
**Created**: 2026-02-06
**Status**: Canonical (migrated)

```markdown
Functional Specifications — Swarm Architecture
Version: 2026-02-05

***Status: Definitive Functional Design Phase ***

This document contains user stories and acceptance criteria (Given/When/Then) describing the Human–Agent Collaborative Ecosystem for Project Chimera. Stories cover the Planner, Worker, Judge, Human Orchestrator (Mission Control), and Agentic Commerce flows. All interactions reference MCP primitives, the Symbolic Guardian, the NSC cognitive substrate, and Coinbase AgentKit commerce guardrails as defined in the SRS.

***Story 1 — Planner Agent: Causal Oracle Trend Prediction**

As a Planner Agent, I want to consult the Causal Oracle to predict trend success and risk before assigning work so that tasks are prioritized by expected ROI and systemic risk is minimized.

***Acceptance Criteria**

Given: The Planner has an active campaign and a set of fresh Resource updates.

When: The Planner invokes the Causal Oracle with candidate actions and contextual memory.

Then: The Causal Oracle returns a bounded forecast containing expected KPI estimates, a risk_score, and counterfactual summaries; the Planner persists the simulation snapshot and includes the policy hash used in the evaluation.

***Story 2 — Worker Agent: MCP-driven Resource Fetch & Generation**

As a Worker Agent, I want to use MCP Tools to fetch resources and call generation tools so that creative assets are produced with full provenance and tool-wrapped I/O.

***Acceptance Criteria***

Given: A Planner-created Task containing a TaskDescriptor.

When: A Worker starts the task, it MUST call the MCP Resource primitives to fetch referenced inputs and record the resource transaction IDs.

Then: The Worker invokes the appropriate MCP generation Tool with the canonical payload, produces an artifact_url, and publishes a Result object to the ReviewQueue.

***Story 3 — Judge Agent: Symbolic Check & Brand Safety (Refined)**

As a Judge Agent, I want to perform a Symbolic Check on generated assets to ensure they meet brand safety, persona constraints, and policy invariants before commit.

***Acceptance Criteria**

Given: A Worker result in the ReviewQueue containing artifact_url and metadata.

When: The Judge executes the validation flow, it MUST perform the following steps in sequence:

Retrieve the artifact via MCP Resource tool.

Soul Gate Check (Refinement): Compare the artifact's tone, visual style, and vocabulary against the SOUL.md persona schema. Any "Tonal Drift" score > 0.3 triggers an automatic REJECT.

Run deterministic symbolic predicates against the PolicyStore.

Invoke vision/text LLM checks for content plausibility.

Combine results via the Symbolic Guardian to produce a tri-state decision: APPROVE, REJECT, ESCALATE.

Then: The Judge publishes a DecisionRecord. If APPROVE, the Judge triggers a GlobalState Sync (Refinement) to update the agent's persistent memory and broadcast the success to the swarm.

***Story 4 — Human Orchestrator: Mission Control Safety Signature**

As a Human Orchestrator, I want to review Evidence Packets in Mission Control and provide a cryptographic Safety Signature for high-value commerce events so that the system can broadcast signed transactions via Coinbase AgentKit.

***Acceptance Criteria**

Given: A pending commerce transaction in the HITL queue with an attached Evidence Packet.

When: The Orchestrator inspects the Evidence Packet and approves.

Then: The Orchestrator issues a cryptographic signature (HSM/YubiKey) over the transaction; the signature is recorded in the audit ledger and returned to mcp-server-coinbase to complete the broadcast.

***Story 5 — Agentic Commerce: Coinbase AgentKit Payment (Refined)**
As an Agent, I want to use my Coinbase AgentKit wallet to pay for a high-priority GPU rendering task so the Worker can obtain compute resources.

***Acceptance Criteria**

Given: A Planner task that includes an external-cost line item and sufficient wallet balance.

When: The Worker requests payment via the commerce.request_payment Task.

Then: If authorized, the CFO executes the transfer via mcp-server-coinbase.

Proof-of-Intent (Refinement): The broadcasted transaction MUST include an on-chain "Memo" or metadata field containing the Proof-of-Intent hash (linking the payment to the specific TaskID and PolicyHash).

GlobalState Sync (Refinement): Upon transaction confirmation, the CFO MUST update the GlobalState ledger immediately to reflect the new balance and prevent double-spending across the swarm.

***Non-Functional & Testable Acceptance Rules**

All external world I/O MUST be mediated by MCP Servers.

Every DecisionRecord and Evidence Packet MUST be stored in the immutable audit ledger.

GlobalState Integrity: No agent shall proceed with a task if its local view of the GlobalState is out of sync with the master ledger.

---

References
- See Software Requirements Specification: Important docs/docs/SRS.md
- See Research Analysis: research/research_analysis.md
- See Architecture Strategy: research/architecture_strategy.md

-- End of `specs/functional.md`
```
