# Freepik MCP - Coolify / Docker deployment
# Uses streamable-http transport so the server listens on a port

FROM python:3.12-slim

WORKDIR /app

# Install uv (official distroless image)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy dependency files first for better layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies (no dev group for production)
ENV UV_NO_DEV=1
RUN uv sync --locked

# Copy application code
COPY main.py ./
COPY src ./src

# Expose the streamable-http port (Coolify will map this)
ENV PORT=3000
# Required for MCP streamable-http transport (auth handled by Coolify/reverse proxy)
ENV DANGEROUSLY_OMIT_AUTH=true
EXPOSE 3000

# Run MCP server with HTTP transport for Coolify
# Set FREEPIK_API_KEY in Coolify Environment Variables
CMD uv run fastmcp run main.py --transport streamable-http --port ${PORT}
