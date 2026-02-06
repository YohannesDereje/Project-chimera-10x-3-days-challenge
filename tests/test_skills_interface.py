import pytest

from src.skills_gate import MediaDownloader, Transcriber


def test_media_downloader_run_returns_file_path():
    md = MediaDownloader()
    result = md.run({"url": "http://example.com/video.mp4"})

    assert isinstance(result, dict)
    # Contract requires 'file_path' in the result (test should fail while stub returns {})
    assert "file_path" in result


def test_transcriber_run_returns_transcript_text():
    tr = Transcriber()
    result = tr.run({"file_path": "/tmp/video.mp4"})

    assert isinstance(result, dict)
    # Contract requires 'transcript_text' in the result (test should fail while stub returns {})
    assert "transcript_text" in result
