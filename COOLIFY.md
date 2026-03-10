# Deploying Freepik MCP to Coolify

Use these settings in Coolify so the MCP server runs with **streamable-http** on a port (required for HTTP health checks and routing).

---

## Option A: Nixpacks (often fails — use Option B if it does)

### 1. General

| Field | Value |
|-------|--------|
| **Name** | `Freepik MCP` (or your app name, e.g. `satva-git/freepik-mcp:main-...`) |
| **Build Pack** | **Nixpacks** |
| **Is it a static site?** | **No** (unchecked) |
| **Domains** | Your Coolify domain (e.g. `http://....sslip.io` or custom) |
| **Direction** | `Allow www & non-www.` (or as you prefer) |

### 2. Build (Nixpacks)

| Field | Value |
|-------|--------|
| **Install Command** | `curl -LsSf https://astral.sh/uv/install.sh | sh && export PATH="$HOME/.local/bin:$PATH" && uv sync --no-dev` |
| **Build Command** | *(leave empty)* |
| **Start Command** | `DANGEROUSLY_OMIT_AUTH=true uv run fastmcp run main.py --transport streamable-http --port ${PORT:-3000}` |
| **Base Directory** | `/` |
| **Publish Directory** | `/` |
| **Watch Paths** | `src/**` |

### 3. Port

Set the application **port** to **3000** (in Coolify’s port / exposed port setting).

### 4. Environment Variables

| Name | Value |
|------|--------|
| `FREEPIK_API_KEY` | Your Freepik API key from [freepik.com/api](https://freepik.com/api) |

Optional: `PORT` = `3000` (if Coolify doesn’t set it).

**Note:** Nixpacks' Python image has no pip (`No module named pip`). The install command above uses **uv** instead. If the build still fails, use **Option B (Dockerfile)** — it works reliably.

---

## Option B: Dockerfile (recommended)

### 1. General

| Field | Value |
|-------|--------|
| **Name** | `Freepik MCP` (or your app name) |
| **Build Pack** | **Dockerfile** |
| **Is it a static site?** | **No** (unchecked) |
| **Base Directory** | `/` |
| **Publish Directory** | `/` |
| **Watch Paths** | `src/**` (optional) |

Leave **Install / Build / Start** empty; the Dockerfile defines the build and run.

### 2. Port & Environment

- **Port:** `3000`
- **Environment Variables:** `FREEPIK_API_KEY` = your API key

---

## Other settings (both options)

- **Docker Registry:** Leave **Docker Image** and **Docker Image Tag** empty unless you push to an external registry.
- **Healthcheck:** If the app exits, you may need to disable health check or use a TCP check on port 3000 (MCP HTTP may not expose a simple `/` path).

---

## Checklist

- [ ] **Build Pack:** Nixpacks (Option A) or Dockerfile (Option B).
- [ ] **Port:** 3000.
- [ ] **Env:** `FREEPIK_API_KEY` set in Coolify.
- [ ] **Domain** set; deploy and check **Logs** if status is Exited.

---

## Troubleshooting

- **`pip: command not found` or `No module named pip`:** Nixpacks’ install step doesn’t have `pip` on PATH. Use the uv-based Install Command in Option A, or switch to Option B (Dockerfile).
- **Exited on start:** Check **Logs** for missing `FREEPIK_API_KEY`, `ModuleNotFoundError`, or wrong Python version. With Nixpacks, if install or `fastmcp` fails, switch to Option B (Dockerfile).
- **Connection refused:** Ensure port 3000 is set in Coolify and the domain routes to this service.
- **Invalid API key:** Verify `FREEPIK_API_KEY` in Environment Variables (no extra spaces).
