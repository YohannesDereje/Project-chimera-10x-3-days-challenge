# Skill: Trend Analyzer

Purpose
- Analyze trend signals and return a ranked topic list with confidence scores.

Inputs
- query (string): Topic or domain to analyze.
- timeframe (string, optional): Time window (e.g., "24h", "7d").
- filters (object, optional): Structured filters for data sources.

Outputs
- trend_id (string): Unique identifier for the trend analysis.
- topic (string): Primary topic returned.
- confidence_score (number): Confidence score (0.0-1.0).
- timestamp (string): ISO-8601 timestamp of the analysis.

Errors
- Raise if query is missing.

Example
```json
{
  "query": "short-form video trends",
  "timeframe": "7d"
}
```
