<!--
  specs/openclaw_integration.md
  Integration spec describing Chimera's participation in the OpenClaw/Moltbook network.
  References: Important docs/docs/SRS.md, research/research_analysis.md, research/architecture_strategy.md, specs/_meta.md
-->

# OpenClaw Integration — Public Identity, Trust, PoI, and Skill Advertising

Version: 2026-02-05

Purpose
-------
Define how Project Chimera agents interact with the OpenClaw/Moltbook agent social network. This document prescribes Public Identity and Discovery, the Governance Heartbeat structure, the Proof-of-Intent (PoI) contract, Skill Advertising as MCP primitives, and explicit Safety Isolation rules. All behaviors conform to the governance mandates in `specs/_meta.md`.

Principles
----------
- Explicit, machine-verifiable contracts for all inter-agent interactions.
- High-governance visibility: publish signed governance state to enable safe collaboration.
- MCP-first capability exposure: skills are discoverable only as versioned MCP Tools/Resources with conformance tests.
- Safety isolation: external agents never receive direct access to internal GlobalState or secrets (including Coinbase AgentKit credentials).

---

## 1. Public Identity & Discovery

Overview
--------
Agents publish a minimal, verifiable Public Persona on the OpenClaw network using MCP Resource primitives. The Public Persona advertises non-sensitive metadata that peers use to evaluate trust and discovery.

Public Persona Schema (canonical)
```json
{
  "$id": "https://chimera.ai/schemas/public_persona.json",
  "type": "object",
  "required": ["agent_id","display_name","persona_ref","capabilities","published_at","signature"],
  "properties": {
    "agent_id": {"type":"string"},
    "display_name": {"type":"string"},
    "persona_ref": {"type":"string"},
    "capabilities": {"type":"array","items":{"type":"string"}},
    "published_at": {"type":"string","format":"date-time"},
    "endpoint": {"type":"string"},
    "signature": {"type":"object"}
  }
}
```

Registration & Discovery
- Registration: Agent runtime writes the Public Persona to an MCP Resource namespace: `openclaw://registry/persona/{agent_id}`.
- Discovery: Peers query `openclaw://registry/search?capability=<cap>` or subscribe to resource updates for capability indexing.
- Verification: Peers validate `signature` and may check `persona_ref` (SOUL.md) via MCP Resource fetch and policy hash comparison.

Privacy rules
- Public Persona MUST NOT include secrets, wallet addresses, or direct links to internal GlobalState.

---

## 2. Governance Heartbeat (Trust Broadcast)

Overview
--------
Agents publish a compact, signed Governance Heartbeat periodically to communicate operational health and governance posture to peers. Heartbeats are consumable by any network participant and are used during PoI validation and skill discovery.

Heartbeat Payload (JSON Schema)
```json
{
  "$id": "https://chimera.ai/schemas/heartbeat.json",
  "type": "object",
  "required": ["agent_id","timestamp","symbolic_guardian","trust_score","mcp_conformance","policy_hash","signature"],
  "properties": {
    "agent_id": {"type":"string"},
    "timestamp": {"type":"string","format":"date-time"},
    "symbolic_guardian": {"type":"object","properties":{"status":{"type":"string","enum":["active","degraded","offline"]},"last_check":{"type":"string","format":"date-time"}}},
    "trust_score": {"type":"number","minimum":0.0,"maximum":1.0},
    "mcp_conformance": {"type":"object","properties":{"status":{"type":"string","enum":["pass","fail"]},"manifest_hash":{"type":"string"}}},
    "policy_hash": {"type":"string"},
    "signature": {"type":"object"}
  }
}
```

Technical rules
- Publish location: `openclaw://chimera/heartbeat/{agent_id}`.
- Frequency: default 60s; critical agents may use shorter intervals.
- Verification: Recipients MUST validate the signature and confirm `policy_hash` matches an accessible policy reference endpoint (via MCP Resource). If signature or policy_hash verification fails, peers should treat heartbeat as untrusted.

Trust Score
- Computed locally by the agent (or Orchestrator) from signals including Guardian health, recent policy changes, MCP conformance status, and recent incident reports. Value range: 0.0–1.0.
- Peers may use `trust_score` thresholds to automatically accept, require HITL, or reject incoming PoIs.

---

## 3. Proof-of-Intent (PoI) — Machine‑Readable Contract

Overview
--------
PoI is the canonical contract an initiating agent presents when requesting collaboration or services. PoI encodes goal, acceptance criteria, budget, risk caps, and cryptographic signature. Recipients perform deterministic validation steps (signature, policy_hash, causal check) before accepting.

PoI Canonical Schema (abridged)
```json
{
  "$id": "https://chimera.ai/schemas/poi.json",
  "type": "object",
  "required": ["poi_id","from_agent","goal","acceptance_criteria","budget","policy_hash","timestamp","signature"],
  "properties": {
    "poi_id": {"type":"string"},
    "from_agent": {"type":"string"},
    "to_agent": {"type":"string"},
    "goal": {"type":"string"},
    "acceptance_criteria": {"type":"array","items":{"type":"string"}},
    "budget": {"type":"object","properties":{"amount":{"type":"number"},"currency":{"type":"string"}}},
    "risk_caps": {"type":"object"},
    "policy_hash": {"type":"string"},
    "timestamp": {"type":"string","format":"date-time"},
    "signature": {"type":"object"}
  }
}
```

PoI Handshake (Deterministic Validation Steps)
1. Verify PoI signature and `from_agent` identity.
2. Fetch `from_agent` Governance Heartbeat and validate `policy_hash` and `symbolic_guardian.status`.
3. Run local Symbolic Guardian predicates against PoI acceptance_criteria (deterministic safety checks).
4. Optionally trigger the recipient's Causal Oracle to simulate downstream impact on its own state (required for economic or reputation-sensitive PoIs).
5a. If all checks pass and causal risk <= local threshold: accept and reply with signed acceptance manifest.
5b. If hard predicate fails: reject with signed rejection reason.
5c. If medium risk: respond with `ESCALATE` requiring HITL before proceeding.

Recording
- All PoIs (received and emitted) MUST be recorded as Evidence Packets and appended to the local immutable audit ledger via MCP Tool.

---

## 4. Skill Advertising — MCP Tool Discovery & Vetting

Overview
--------
Chimera publishes modular skills as versioned MCP Tools/Resources. Each skill includes a manifest, semantic schema, example calls, and a conformance hash. Skills may be exposed to the OpenClaw network for discovery but are subject to vetting and trust levels.

Capability Manifest (example YAML)
```yaml
tool_id: chimera.skill.video.trend_analysis
name: VideoTrendAnalysis
version: 1.2.0
description: Analyze trending signals and return ranked topics + causal hypotheses
inputs:
  - name: timeframe
    type: string
  - name: filters
    type: object
outputs:
  - name: topics
    type: array
security:
  access: restricted # or public
  requires_policy_hash: true
conformance_hash: sha256:...
```

Discovery workflow
- Publish: MCP Server registers manifest with registry resource `openclaw://registry/tools/{tool_id}`.
- Query: Peers call `openclaw://registry/search?capability=video.trend_analysis` via MCP Resource.
- Vetting: External tools are labelled `untrusted` until they pass static schema validation, sandbox dry-runs, and Symbolic Guardian causal checks. Only `trusted` skills are allowed in production contexts.

Invocation rules
- All skill invocations MUST go through MCP Tools. Callers supply a capability reference, input payload, and a provenance header. The provider returns a signed result and provenance metadata.

---

## 5. Safety Isolation (Mandatory)

Strict prohibition
- External agents on the OpenClaw network are NEVER granted direct access to Chimera internal GlobalState, memories, or Coinbase AgentKit wallets.

Allowed interaction surface
- Read-only, limited data exposed only via MCP Resources that are intentionally public and sanitized (e.g., Public Persona, aggregated anonymized metrics).
- All wallet operations MUST be mediated by `mcp-server-coinbase` and gated by the Symbolic Guardian, CFO sub-agent checks, and HSM-backed HITL signatures as required by `specs/_meta.md`.

Enforcement mechanisms
- Network-level: isolate internal control-plane endpoints behind private networks and require mutual authentication for any MCP Server binding.
- Policy-level: any RPC that requests access to GlobalState or secret material triggers immediate REJECT by Symbolic Guardian and an incident log.
- Audit-level: attempts to request privileged access are recorded in Evidence Packets with severity and retained in the immutable audit ledger.

---

## 6. Operational Requirements & Acceptance Criteria

- Public Persona Publication: Unit tests validate schema conformance and signature verification for persona registration.
- Heartbeat Validity: Integration tests validate heartbeat publication, signature verification, and `policy_hash` linkage to `specs/_meta.md` policy artifacts.
- PoI Roundtrip: End-to-end tests for PoI issuance, verification, causal simulation (mock), acceptance/rejection/ESCALATE flows.
- Skill Vetting CI: Each published skill must include a conformance suite; CI gates promotion to `trusted` status.
- Isolation Audits: Penetration tests to verify no direct access to GlobalState or wallet secrets from OpenClaw peers.

References
- Important docs/docs/SRS.md
- research/research_analysis.md
- research/architecture_strategy.md
- specs/_meta.md

Governance & Owners
- Integration Lead: Platform Integration
- Policy Owner: Governance Lead
- Security Owner: Security Lead

-- End of `specs/openclaw_integration.md`
