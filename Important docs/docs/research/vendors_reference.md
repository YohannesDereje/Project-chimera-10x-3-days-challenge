# One-Page Vendor Reference — a16z "Trillion Dollar AI Dev Stack"

A concise reference of vendors mentioned in the a16z article and why they matter to Project Chimera research.

| Vendor | Category | What they do (short) | Relevance to Project Chimera | Risk / Cost signal |
|---|---|---:|---|---|
| Cursor | Editor / Agent IDE | Code-first IDE with agentic features, tab-complete and background agents | Example for Planner/Worker integration and editor-driven agents | High-productivity; vendor lock and model cost tradeoffs |
| Windsurf | Editor / Agent tooling | AI-assisted editor tools acquired by big players | Shows incumbents integrating AI in IDEs | Strategic incumbent consolidation |
| GitHub Copilot | In-IDE assistant | Autocomplete and code suggestions inside VS Code | Useful for local developer productivity; cheap model routing pattern | Low per-op cost, high infra dependence on upstream models |
| Sourcegraph / Amp | Code search & indexing | Cross-repo code search, call-graph analysis, ranking relevant files | Critical for agent RAG on large codebases | Index freshness and cost for very large repos |
| Devin | Background agents | Autonomous agent that can create PRs and run tasks over time | Model for background Planner/Worker automation | Requires robust sandboxing and provenance tracking |
| Anthropic Code (Claude Code) | Large reasoning model | High-context reasoning for multi-file edits and planning | Candidate for Planner/Judge roles | High token cost; strong safety features |
| Replit / Vercel / Bolt / Stackblitz | App builders / sandboxes | Rapid prototyping and live dev sandboxes | Useful for safe execution and app prototyping | Sandbox isolation and reproducibility concerns |
| Gitbutler | Intent/version control | Tracks prompts, intent, and semantic diffs instead of raw text diffs | Aligns with intent-versioning and provenance needs | New paradigm; integration effort with Git workflows |
| Graphite / CodeRabbit | AI code review | Automated PR reviews focusing on correctness and security | Example CI gating for spec and security checks | Risk of false positives/negatives; trust calibration needed |
| Mintlify / Context7 | Docs & runtime context | Dynamic, queryable docs for both humans and LLMs | Maps to SOUL.md / technical.md being machine-readable | Docs drift if not tied to CI or tests |
| Nexoro / Delty / Traycer | Planning / spec tooling | Tools that help break specs into tickets and decisions | Useful for Plan → Code → Review discipline | Tooling lock-in vs. exporting specs required |
| Relace | Code-relevance ranking | Models to rank and identify relevant files for LLMs | Improves RAG quality for agents operating on repo | Cost of building call-graphs at scale |
| Exa / Brave / Tavily | Web search APIs | Fast external knowledge retrieval for agents | External RAG sources for trend detection and perception | External API reliability and cost |
| E2B / Daytona / Morph / Runloop / Together | Execution sandboxes | Secure environments to run untrusted code and tests | Essential for running agent-generated code safely | Sandbox fidelity and reproducibility tradeoffs |
| Mintlify / Delve | Compliance & security docs | Compliance-focused doc generation and auditing | Helps meet NFRs (transparency, audits) | Completeness depends on input spec quality |
| Gumloop | Product-extension automation | Apps that let product owners request new features that agents implement | Demonstrates app self-extension concept | Potential for drift and silent regressions |
| Sourcegraph (repeat) | See above | — | Critical for large-repo agent context | — |
| Cursor Background Agents (feature) | Background agents | Autonomous PRs and long-running tasks | Directly maps to Planner/Worker background workflows | Needs governance and CI safeguards |

Notes:
- This reference is intentionally concise—use it to identify one exemplar vendor per category when writing `technical.md`.
- Suggested next step: pick one vendor per column (Search, Sandbox, Docs, Review) and add integration notes (APIs, auth, provable guarantees) in `technical.md`.
