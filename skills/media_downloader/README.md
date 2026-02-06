# Skill: Media Downloader

Purpose
- Download a media asset from a URL into a local path for downstream processing.

Inputs
- url (string): Source URL for the media asset.
- destination_dir (string, optional): Directory to place the downloaded file.

Outputs
- file_path (string): Absolute or workspace-relative path to the downloaded file.
- media_type (string, optional): Detected media type (video/audio/image).

Errors
- Raise if url is missing or unreachable.

Example
```json
{
  "url": "https://example.com/video.mp4",
  "destination_dir": "/tmp"
}
```
