# Transcriber Skill

Description
-----------
Transcribes audio and extracts timestamps and speaker segments. Intended for Worker agents to convert raw audio artifacts into structured text for memory ingestion and content generation.

Input Contract (JSON Schema)
----------------------------
```json
{
  "$id": "https://chimera.ai/schemas/transcriber.input.json",
  "type": "object",
  "required": ["agent_id","artifact_url","language"],
  "properties": {
    "agent_id": {"type":"string"},
    "artifact_url": {"type":"string","format":"uri"},
    "language": {"type":"string","minLength":2},
    "diarization": {"type":"boolean"},
    "timestamps": {"type":"boolean"}
  }
}
```

Output Contract (JSON Schema)
-----------------------------
```json
{
  "$id": "https://chimera.ai/schemas/transcriber.output.json",
  "type": "object",
  "required": ["agent_id","transcript_text","confidence_score"],
  "properties": {
    "agent_id": {"type":"string"},
    "transcript_text": {"type":"string"},
    "segments": {"type":"array","items":{"type":"object","required":["start","end","text"],"properties":{"start":{"type":"string","format":"duration"},"end":{"type":"string","format":"duration"},"text":{"type":"string"},"speaker":{"type":"string"}}}},
    "language": {"type":"string"},
    "confidence_score": {"type":"number","minimum":0.0,"maximum":1.0},
    "artifact_ref": {"type":"string"}
  }
}
```

Dependency List
---------------
- openai-whisper (or whisper-openai)
- ffmpeg
- numpy
- httpx

Governance & Notes
------------------
- Transcription must not expose private content; any PII detected should be marked and routed to HITL per `specs/functional.md` sensitivity rules.
- Results must be stored in semantic memory (Weaviate) with provenance metadata.

References
----------
- Important docs/docs/SRS.md
- research/research_analysis.md
- specs/functional.md

-- End of Transcriber
