<div align="center">

<img src="docs/assets/icon.png" width="128" alt="Logo">

# Perplexity WebUI Scraper

Python scraper to extract AI responses from [Perplexity's](https://www.perplexity.ai) web interface.

[![PyPI](https://img.shields.io/pypi/v/perplexity-webui-scraper?color=blue)](https://pypi.org/project/perplexity-webui-scraper)
[![Python](https://img.shields.io/pypi/pyversions/perplexity-webui-scraper)](https://pypi.org/project/perplexity-webui-scraper)
[![License](https://img.shields.io/github/license/henrique-coder/perplexity-webui-scraper?color=green)](./LICENSE)

</div>

---

**📚 Full Documentation & Advanced Guide:** [https://henrique-coder.github.io/perplexity-webui-scraper](https://henrique-coder.github.io/perplexity-webui-scraper)

---

## What is this?

This library lets you interact with Perplexity AI programmatically using the same web endpoints as the browser — no official API key required. It supports conversations, file uploads, streaming, an MCP server for AI agents, and a drop-in OpenAI-compatible REST API.

- **Requirements:** A Perplexity Pro or Max account and your browser session token.
- **Key Features:** 15 models (GPT-5.4, Claude Opus, Gemini, Deep Research…), file attachments (images, PDFs, …), streaming, MCP Server for AI agents, OpenAI-compatible REST API, multi-turn conversation thread continuation.

## Quick Start (Docker)

### 1. Prerequisites

- Docker or Podman installed
- A Perplexity Pro/Max account
- Your `__Secure-next-auth.session-token` from `perplexity.ai`

### 2. Published Images

- API image (OpenAI-compatible REST server): `ghcr.io/sparshbajaj/perplexity-webui-scraper-docker:latest`
- MCP image (MCP stdio server): `ghcr.io/sparshbajaj/perplexity-webui-scraper-docker:mcp`

```bash
docker pull ghcr.io/sparshbajaj/perplexity-webui-scraper-docker:latest
docker pull ghcr.io/sparshbajaj/perplexity-webui-scraper-docker:mcp
```

### 3. Run the OpenAI-compatible API container

```bash
# Exposes API at http://localhost:8000
docker run --rm -p 8000:8000 \
  -e TZ=UTC \
  ghcr.io/sparshbajaj/perplexity-webui-scraper-docker:latest
```

Authentication is request-based (OpenAI style). Send your Perplexity session token in the `Authorization` header with bearer format.
Example token format: `SESSION_TOKEN_VALUE`.

Use your client to call `http://localhost:8000/v1/chat/completions` and include the authorization header with your session token.

### 4. Run the MCP container

```bash
docker run --rm -i \
  -e PERPLEXITY_SESSION_TOKEN=YOUR_SESSION_TOKEN \
  ghcr.io/sparshbajaj/perplexity-webui-scraper-docker:mcp
```

`PERPLEXITY_SESSION_TOKEN` is required for MCP mode.

## Docker Compose

This repo includes a `docker-compose.yml` file in the repository root with both services:

```bash
# API only
docker compose up -d perplexity-api

# MCP only (set token first)
export PERPLEXITY_SESSION_TOKEN=YOUR_SESSION_TOKEN
docker compose up -d perplexity-mcp
```

You can also place the token in a local `.env` file:

```env
PERPLEXITY_SESSION_TOKEN=YOUR_SESSION_TOKEN
```

## Environment variables

| Variable                   | Where required               | Description                                                              |
| -------------------------- | ---------------------------- | ------------------------------------------------------------------------ |
| `PERPLEXITY_SESSION_TOKEN` | API requests and MCP runtime | API: sent in `Authorization` header. MCP: set as container env variable. |
| `TZ`                       | Optional                     | Container timezone (example: `UTC`)                                      |

## OpenAI-Compatible API endpoints

| Method | Path                   | Description                                 |
| ------ | ---------------------- | ------------------------------------------- |
| `GET`  | `/v1/models`           | List all available models                   |
| `POST` | `/v1/chat/completions` | Chat completion (streaming + non-streaming) |
| `GET`  | `/docs`                | Interactive Swagger UI                      |
| `GET`  | `/redoc`               | ReDoc documentation                         |

> Fields not supported by Perplexity (e.g. `temperature`, `top_p`) are accepted for client compatibility but silently ignored.

## Disclaimer

This is an **unofficial** library. It uses internal APIs that may change without notice. Use at your own risk. By using this library, you agree to Perplexity AI's [Terms of Service](https://www.perplexity.ai/hub/legal/terms-of-service).
