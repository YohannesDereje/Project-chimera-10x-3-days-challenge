# Media Downloader Skill

Description
-----------
Downloads media assets from public sources (video/audio/image) via provided URLs and stores them in a canonical artifact store. Designed for Worker agents to fetch source materials for downstream generation or transcription.

Input Contract (JSON Schema)
----------------------------
```json
{
  "$id": "https://chimera.ai/schemas/media_downloader.input.json",
  "type": "object",
  "required": ["agent_id","url","expected_format"],
  "properties": {
    "agent_id": {"type":"string"},
    "url": {"type":"string","format":"uri"},
    "expected_format": {"type":"string","enum":["mp4","mp3","wav","jpg","png"]},
    "timeout_seconds": {"type":"integer","minimum":1,"maximum":3600},
    "checksum": {"type":"string"}
  }
}
```

Output Contract (JSON Schema)
-----------------------------
```json
{
  "$id": "https://chimera.ai/schemas/media_downloader.output.json",
  "type": "object",
  "required": ["agent_id","artifact_url","file_size_bytes","format","confidence_score"],
  "properties": {
    "agent_id": {"type":"string"},
    "artifact_url": {"type":"string","format":"uri"},
    "file_path": {"type":"string"},
    "file_size_bytes": {"type":"integer","minimum":0},
    "format": {"type":"string"},
    "checksum": {"type":"string"},
    "confidence_score": {"type":"number","minimum":0.0,"maximum":1.0}
  }
}
```

Dependency List
---------------
- yt-dlp
- ffmpeg
- httpx
- aiofiles

Governance & Notes
------------------
- The downloader MUST validate the source URL via MCP Resource access rules and must not perform unauthenticated scraping of private resources.
- All downloaded artifacts must be registered in the artifact registry and return a signed `artifact_url` provenance record.

References
----------
- Important docs/docs/SRS.md
- research/architecture_strategy.md

-- End of Media Downloader
