from __future__ import annotations
from pydantic import BaseModel


class TrendModel(BaseModel):
    trend_id: str
    topic: str
    confidence_score: float
    timestamp: str


class TrendFetcher:
    """Minimal TrendFetcher stub used for TDD.

    - `fetch_trend` returns an empty dict to force downstream assertion failures.
    - `validate_trend` attempts to parse input into a `TrendModel` and will raise
      `pydantic.ValidationError` for malformed input (used by tests).
    """

    def fetch_trend(self, query: str):
        # Intentionally return an empty dict to make the structural assertion fail.
        return {}

    def validate_trend(self, data: dict) -> TrendModel:
        # Use Pydantic model to validate and raise ValidationError on malformed data.
        return TrendModel(**data)
