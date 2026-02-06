FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install minimal system deps and curl for the uv installer
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install uv (official installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv and local user bins are on PATH for both root and non-root users
ENV PATH="/root/.local/bin:/home/chimera/.local/bin:/usr/local/bin:$PATH"

# Create app directory and copy project
WORKDIR /app
COPY . /app

# Create non-root user 'chimera' and give ownership of /app
RUN adduser --disabled-password --gecos "" chimera \
    && chown -R chimera:chimera /app

# Install dependencies using uv. Prefer a frozen sync; fall back to an editable
# install if sync is not applicable in this environment.
RUN set -eux; \
    if uv --version >/dev/null 2>&1; then \
        uv sync --frozen || uv pip install -e .; \
    else \
        pip install --no-cache-dir -e .; \
    fi

# Create a self-contained venv under /app so the runtime interpreter is
# accessible by the non-root `chimera` user. This avoids uv placing the
# interpreter under /root/.local which is inaccessible to non-root users.
RUN set -eux; \
    # Install the project and its dependencies system-wide so the interpreter
    # used is the system python (avoids uv-managed root-owned interpreter).
    python3 -m pip install --no-cache-dir -e .; \
    # Install test and CI tooling so pytest/lint/security run in the image
    python3 -m pip install --no-cache-dir pytest pytest-asyncio ruff bandit; \
    chown -R chimera:chimera /app

# Run as non-root for improved security (after installs and chown)
USER chimera

# Default command runs tests using the system python
CMD ["python3", "-m", "pytest", "tests/"]
