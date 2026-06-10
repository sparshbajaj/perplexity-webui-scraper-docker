# ──────────────────────────────────────────────
#  Build stage – install deps with uv
# ──────────────────────────────────────────────
FROM python:3.12-slim AS builder

# Install uv (fast Python package manager used by this project)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Copy project files needed for installation
COPY pyproject.toml uv.lock README.md ./
COPY src/ ./src/

# Install the package + all extras (api, mcp, cli) into /app/.venv
RUN uv sync --frozen --extra api --extra mcp --extra cli --no-dev

# ──────────────────────────────────────────────
#  Runtime stage – lean final image
# ──────────────────────────────────────────────
FROM python:3.12-slim AS runtime

WORKDIR /app

# Copy the pre-built venv and source from the builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src   /app/src

# Make the venv's binaries available without activating it
ENV PATH="/app/.venv/bin:$PATH"

# Expose the API port
EXPOSE 8000

# Health-check – pings the /health endpoint every 30 s
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" \
    || exit 1

# Default: run the OpenAI-compatible REST API on all interfaces
CMD ["perplexity-webui-scraper", "api", "--host", "0.0.0.0", "--port", "8000"]
