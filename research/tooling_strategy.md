Developer Tooling Strategy — MCP Stack

Version: 2026-02-05

Purpose
-------
This document defines the Developer MCP Stack used to operate, test, and maintain Project Chimera code and infrastructure. The stack satisfies governance requirements in specs/_meta.md and supports auditable workflows.

Developer MCP Stack
-------------------
1) @modelcontextprotocol/server-filesystem
- Purpose: Controlled filesystem access for read/write operations with audit logs.
- Capabilities: read_file, list_dir, write_file, create_directory, stat.

2) mcp-server-git
- Purpose: Controlled Git operations for traceability (status, diff, commit, branching).
- Capabilities: git_status, git_diff, git_commit, git_create_branch, git_merge, git_log.

3) @modelcontextprotocol/server-sequential-process
- Purpose: Run build/test/lint steps as deterministic sequences with structured logs.
- Capabilities: run_command, run_sequence, get_run_artifacts, cancel_run.

Acceptance Criteria
-------------------
- All MCP servers pass conformance tests before production use.
- Any policy file change requires audit evidence and human review.

References
----------
- specs/_meta.md
- research/architecture_strategy.md
- research/research_analysis.md

-- End of tooling_strategy.md
