<!--
  Wrapped Spec Kit file: .specify/specs/research/tooling_strategy.md
  Migrated from research/tooling_strategy.md — content preserved.
-->

# Feature Specification: Developer Tooling Strategy — MCP Stack

**Feature Branch**: `[migration/specs-into-spec-kit]`
**Created**: 2026-02-06
**Status**: Canonical (migrated)

```markdown
<!--
  research/tooling_strategy.md
  Developer MCP Stack and guidance for Project Chimera
  References: Important docs/docs/SRS.md, research/architecture_strategy.md, research/research_analysis.md, specs/_meta.md
-->

# Developer Tooling Strategy — MCP Stack

Version: 2026-02-05

Purpose
-------
This document defines the Developer MCP Stack used to operate, test, and maintain Project Chimera code and infrastructure. The stack is selected to satisfy the project's high-governance requirements (traceability, auditable change control, sandboxed execution) as described in `.specify/specs/_meta.md`, the Swarm Architecture in `Important docs/docs/SRS.md`, and the integration constraints in `research/architecture_strategy.md` and `research/research_analysis.md`.

Goals
-----
- Ensure every developer action is observable and auditable through MCP-mediated tools.
- Prevent direct, ad-hoc access to production resources by routing developer operations through server-side MCP servers with conformance checks.
- Provide lightweight, reproducible developer workflows for code editing, Git operations, and sequential process execution (build/test/deploy).

Developer MCP Stack
-------------------
The following MCP servers are the canonical developer-facing toolchain for Project Chimera.

1) @modelcontextprotocol/server-filesystem
----------------------------------------
Purpose
: Provide deep, controlled filesystem access for code editing, directory inspection, and deterministic file operations inside developer sandboxes. This server is used by IDE integrations and automated code-review agents to perform read/write operations while enforcing path and policy constraints.

Capabilities
:
- `read_file(path)` — read a file with path normalization and audit logging
- `list_dir(path)` — enumerates directory contents with metadata
- `write_file(path, content)` — write or overwrite a file (subject to policy and migration rules)
- `create_directory(path)` — create directories with permission checks
- `stat(path)` — return file metadata (size, mtime, hash)

Config Snippet (`.vscode/mcp.json`)
```json
{
  "mcp_servers": [
    {
      "id": "filesystem.local",
      "module": "@modelcontextprotocol/server-filesystem",
      "transport": "stdio",
      "root": "./",
      "policy": {
        "allow_write": true,
        "audit_channel": "mcp://audit/filesystem"
      }
    }
  ]
}
```

Operational notes
:
- All `write_file` operations must produce an Evidence Packet including a diff, policy reference (if persona/policy files changed), and user identity. CI enforces that production changes go through PRs.

2) mcp-server-git
------------------
Purpose
:
Provide controlled Git operations (branching, commits, diffs, merges) via MCP Tools to maintain the project's traceability and change control mandates. This server centralizes automated commits made by agents and records metadata required for audits.

Capabilities
:
- `git_status()` — current working tree status
- `git_diff(refA, refB)` — produce diffs
- `git_commit(message, author, changes)` — create a commit with explicit metadata
- `git_create_branch(name, base)` — create branches for feature or agent-generated changes
- `git_merge(target, source, strategy)` — perform merges (CI-only by policy)
- `git_log(range)` — retrieve commit history with metadata

Config Snippet (`.vscode/mcp.json`)
```json
{
  "mcp_servers": [
    {
      "id": "git.local",
      "module": "mcp-server-git",
      "transport": "stdio",
      "repository_root": "./",
      "policy": {
        "require_review": true,
        "audit_channel": "mcp://audit/git",
        "commit_signature": "agent" 
      }
    }
  ]
}
```

Operational notes
:
- Agent-initiated commits must include a `commit_signature` metadata field. Any commit that changes `.specify/specs/_meta.md`, `SOUL.md`, or policy files must trigger an automated policy regression test and block merge until human approval.

3) @modelcontextprotocol/server-sequential-process
-------------------------------------------------
Purpose
:
Execute build scripts, test suites, linters, and deployment steps as isolated sequential processes. This server provides deterministic ordering, environment sandboxing, resource limits, and structured logs suitable for auditing and triage.

Capabilities
:
- `run_command(cmd, cwd, env, timeout)` — run a single shell command under sandbox controls
- `run_sequence(commands[])` — execute an ordered list of commands, streaming logs and step results
- `get_run_artifacts(run_id)` — retrieve logs, exit codes, and produced artifacts
- `cancel_run(run_id)` — cancel a running sequence

Config Snippet (`.vscode/mcp.json`)
```json
{
  "mcp_servers": [
    {
      "id": "seqproc.local",
      "module": "@modelcontextprotocol/server-sequential-process",
      "transport": "stdio",
      "sandbox": {
        "cpu_quota": "2",
        "memory_mb": 2048,
        "allow_network": false
      },
      "policy": {
        "audit_channel": "mcp://audit/seqproc",
        "require_conformance": true
      }
    }
  ]
}
```

Operational notes
:
- Build and test sequences must run in ephemeral sandboxes without network access by default; network access is allowed only when explicitly approved for integration tests.
- Each sequence execution produces an Evidence Packet with exit codes, logs, artifact hashes, and associated commit refs.

Governance Alignment
--------------------
This Developer MCP Stack enforces the project's governance in `.specify/specs/_meta.md` by:

- Centralizing I/O through MCP servers to prevent direct, ad-hoc access to production APIs and secrets.
- Requiring audit channels for filesystem, git, and process operations so Evidence Packets can be assembled for every developer action.
- Making policy checks and CI conformance requirements first-class in each server's configuration.

Acceptance Criteria for Tooling
------------------------------
- All three MCP servers must pass conformance tests in CI before being allowed in production manifests.
- Every automated commit that modifies policy or persona files must create a PR and run policy regression tests.
- Sequential process runs must produce signed run artifacts and be resumable for triage.

References
----------
- `Important docs/docs/SRS.md` — Swarm architecture and governance
- `research/architecture_strategy.md` — Polyglot persistence and orchestration
- `research/research_analysis.md` — Agent social network considerations
- `.specify/specs/_meta.md` — Governance mandates and acceptance criteria

-- End of `research/tooling_strategy.md`
```
