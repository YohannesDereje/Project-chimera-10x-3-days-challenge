import pytest
from pydantic import ValidationError

# Intentionally import a non-existent class from a non-existent module to ensure the test fails
from src.intelligence import TrendFetcher


def test_fetch_trend_structure():
    """Attempt to fetch a trend and assert its shape.

    This test is expected to fail in the current workspace because
    `src.intelligence.TrendFetcher` does not exist.
    """
    tf = TrendFetcher()
    trend = tf.fetch_trend("sample_query")

    # Accept either a dict or a Pydantic-like model with .dict()
    assert isinstance(trend, dict) or hasattr(trend, "dict")

    if isinstance(trend, dict):
        assert "trend_id" in trend
        assert "topic" in trend
        assert "confidence_score" in trend and isinstance(trend["confidence_score"], float)
        assert "timestamp" in trend
    else:
        data = trend.dict()
        assert "trend_id" in data
        assert "topic" in data
        assert isinstance(data.get("confidence_score"), float)
        assert "timestamp" in data


def test_malformed_raises_validation_error():
    """Pass malformed data (missing confidence_score) and expect ValidationError."""
    tf = TrendFetcher()

    malformed = {
        "trend_id": "t-1",
        "topic": "example",
        # intentionally omit 'confidence_score'
        "timestamp": "2026-02-06T00:00:00Z",
    }

    # Expect that validation of a trend without confidence_score raises ValidationError
    with pytest.raises(ValidationError):
        # Depending on implementation, TrendFetcher may expose a validator method
        # or raise during construction of a Pydantic model; we call a common hook name.
        tf.validate_trend(malformed)
