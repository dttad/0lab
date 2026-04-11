# whois-api

Simple FastAPI service that returns RDAP data for a domain.

## Local dev (uv)

```bash
uv sync
uv run uvicorn App:app --reload
```

Then open: http://127.0.0.1:8000/whois/example.com

Note: WHOIS fallback uses the `python-whois` package (imported as `whois`), not the deprecated `whois`
package name.

## Docker

Build:

```bash
docker build -t whois-api:local .
```

Run:

```bash
docker run --rm -p 8000:8000 whois-api:local
```

## Push to Zot (example)

```bash
docker tag whois-api:local localhost:5000/whois-api:latest
docker push localhost:5000/whois-api:latest
```

If your Zot uses plain HTTP, configure your Docker daemon with an insecure registry entry for
`localhost:5000` on the machine doing the push (including any self-hosted GitHub Actions runner).

## GitHub Actions (push to Zot)

The workflow in `.github/workflows/build-and-push-zot.yml` expects these repo secrets:

- `ZOT_USERNAME` (you said: `dat`)
- `ZOT_PASSWORD` (you said: `dat123`)
- Required: `ZOT_REGISTRY` (the actual Zot host reachable from the GitHub runner, for example `zot.example.com:5000`)
- Optional: `ZOT_REPOSITORY` (for example `whois-api`)

This workflow only builds and pushes an image to Zot. It does not deploy or start a container on your server.
If `ZOT_REGISTRY` points to the wrong host, the workflow can succeed while the image appears in a different registry
than the one you are checking.
