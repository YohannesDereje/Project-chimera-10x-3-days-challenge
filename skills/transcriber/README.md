# Skill: Transcriber

Purpose
- Transcribe audio from a media file into text.

Inputs
- file_path (string): Path to the media file to transcribe.
- language (string, optional): Target language code (e.g., "en").

Outputs
- transcript_text (string): Full transcription text.
- confidence (number, optional): Transcription confidence score (0.0-1.0).

Errors
- Raise if file_path is missing or invalid.

Example
```json
{
  "file_path": "/tmp/video.mp4",
  "language": "en"
}
```
