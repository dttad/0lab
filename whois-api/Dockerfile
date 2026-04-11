FROM python:3.13-slim

WORKDIR /app

# Install uv (used to sync from uv.lock / pyproject.toml)
RUN pip install --no-cache-dir "uv==0.11.4"

# Install dependencies first for better layer caching
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

# Copy application code
COPY App.py ./

ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8000

CMD ["uvicorn", "App:app", "--host", "0.0.0.0", "--port", "8000"]

