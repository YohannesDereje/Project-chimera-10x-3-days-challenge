.PHONY: setup test docker-build docker-test lint security spec-check

setup:
	@echo "Running uv sync to install dependencies from pyproject.toml..."
	uv sync --project .

test: docker-build docker-test
	@echo "Running pytest on /tests via Docker..."

docker-build:
	@echo "Building Docker image project-chimera:latest..."
	docker build -t project-chimera:latest .

docker-test:
	@echo "Running pytest inside Docker container against /tests..."
	docker run --rm project-chimera:latest pytest tests -q

lint: docker-build
	@echo "Running lint checks inside Docker container..."
	docker run --rm project-chimera:latest ruff check .

security: docker-build
	@echo "Running security checks inside Docker container..."
	docker run --rm project-chimera:latest bandit -r src

spec-check:
	@echo "Spec-Check: verifying core spec files are present..."
	@python -c "import os,sys; core=['specs/_meta.md','specs/functional.md','specs/technical.md','specs/openclaw_integration.md']; missing=[p for p in core if not (os.path.exists(p) or os.path.exists(p.replace('specs/','.specify/specs/')) )]; (print('Missing spec files:') or print('\n'.join(' - '+m for m in missing)) or sys.exit(1)) if missing else print('All core spec files present (in specs/ or .specify/specs/)')"
