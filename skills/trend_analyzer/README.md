# Trend Analyzer Skill

Description
-----------
The Trend Analyzer ingests time-bounded social and news resources and returns ranked trending topics with causal hypotheses and estimated KPI forecasts. It is designed to be invoked by Planner agents to inform DAG prioritization and by external orchestrators for strategic insights.

Input Contract (JSON Schema)
----------------------------
```json
{
  "$id": "https://chimera.ai/schemas/trend_analyzer.input.json",
  "type": "object",
  "required": ["agent_id","resource_uris","timeframe","max_topics"],
  "properties": {
    "agent_id": {"type":"string"},
    "resource_uris": {"type":"array","items":{"type":"string","format":"uri"}},
    "timeframe": {"type":"object","required":["start","end"],"properties":{"start":{"type":"string","format":"date-time"},"end":{"type":"string","format":"date-time"}}},
    "filters": {"type":"object"},
    "max_topics": {"type":"integer","minimum":1,"maximum":100}
  }
}
```

Output Contract (JSON Schema)
-----------------------------
```json
{
  "$id": "https://chimera.ai/schemas/trend_analyzer.output.json",
  "type": "object",
  "required": ["agent_id","topics","generated_at","causal_hypotheses"],
  "properties": {
    "agent_id": {"type":"string"},
    "generated_at": {"type":"string","format":"date-time"},
    "topics": {"type":"array","items":{
      "type":"object",
      "required":["topic","score","volume_estimate"],
      "properties":{
        "topic":{"type":"string"},
        "score":{"type":"number","minimum":0.0,"maximum":1.0},
        "volume_estimate":{"type":"integer","minimum":0}
      }
    }},
    "causal_hypotheses": {"type":"array","items":{"type":"object","required":["hypothesis_id","description","predicted_kpis","risk_score"],"properties":{"hypothesis_id":{"type":"string"},"description":{"type":"string"},"predicted_kpis":{"type":"object"},"risk_score":{"type":"number","minimum":0.0,"maximum":1.0}}}},
    "confidence_score": {"type":"number","minimum":0.0,"maximum":1.0}
  }
}
```

Dependency List
---------------
- pandas
- numpy
- scikit-learn
- weaviate-client (for semantic memory lookups)
- httpx (for MCP Resource calls)

Governance & Notes
------------------
- Inputs and outputs conform to the Neuro‑Symbolic standards in `specs/_meta.md` — every output must include `causal_hypotheses` and a normalized `risk_score`.
- All external I/O must use MCP Tools and be logged to the audit ledger.

References
----------
- Important docs/docs/SRS.md
- research/architecture_strategy.md
- research/research_analysis.md

-- End of Trend Analyzer
