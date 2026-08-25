FROM python:3.13-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN addgroup --system appgroup && \
    adduser --system --no-create-home --ingroup appgroup appuser

WORKDIR /code

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-dev --no-install-project


COPY --chown=appuser:appgroup ./app /code/app

ENV PATH="/code/.venv/bin:$PATH"

EXPOSE 80

USER appuser

CMD ["fastapi", "run", "app/main.py", "--port", "80", "--proxy-headers"]