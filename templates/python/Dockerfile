# ---- Build stage ----
FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Runtime stage ----
FROM python:3.12-slim
WORKDIR /app

# Create a non-root user
RUN groupadd -r app && useradd -r -g app -u 10001 app

COPY --from=build /install /usr/local
COPY --chown=app:app . .

USER 10001
EXPOSE 8080
HEALTHCHECK CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1
# Change app.py to your entrypoint (e.g. gunicorn / uvicorn command)
CMD ["python", "app.py"]
