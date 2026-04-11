# 0lab

Personal monorepo. Each subdirectory is an independent project with its own Docker setup and CI/CD pipeline. A single self-hosted GitHub Actions runner on `nuc` (this machine) handles all builds and deploys.

## Repository structure

```
0lab/
├── .github/
│   └── workflows/
│       ├── deploy-ckt.yml       # WordPress staging deploy
│       └── build-sitemap.yml    # Sitemap crawler Docker build
├── ckt/                         # WordPress site (chekimthoa → ckt.d4t0.com)
└── sitemap/                     # Sitemap crawler CLI tool
```

## Infrastructure (on this machine)

| Service | How it runs | Address |
|---------|-------------|---------|
| Self-hosted runner | systemd `actions.runner.dttad-0lab.nuc-runner` | — |
| Zot container registry | Docker container `zotregistry` | `localhost:5000` / `cr.d4t0.com` |
| CKT WordPress (staging) | Docker Compose in `ckt/` | `localhost:8088` / `https://ckt.d4t0.com` |
| Cloudflare tunnel (ckt) | systemd `cloudflared-ckt` | routes `ckt.d4t0.com → localhost:8088` |

### Self-hosted runner

Installed at `/home/dat/actions-runner`, runs as user `dat`.

```bash
# Status
systemctl status actions.runner.dttad-0lab.nuc-runner

# Logs
journalctl -u actions.runner.dttad-0lab.nuc-runner -f

# Restart
sudo systemctl restart actions.runner.dttad-0lab.nuc-runner
```

### Zot registry

Auth: user `dat`, password stored in `/opt/zotregistry/config/htpasswd`.

```bash
# List images
curl -s -u dat:PASSWORD http://localhost:5000/v2/_catalog | python3 -m json.tool

# List tags for an image
curl -s -u dat:PASSWORD http://localhost:5000/v2/sitemap-crawler/tags/list | python3 -m json.tool

# Pull an image
docker pull localhost:5000/sitemap-crawler:staging
```

GitHub Actions secrets required: `ZOT_USER`, `ZOT_PASSWORD`.

---

## Projects

### `ckt/` — WordPress (Chè Kim Thoa staging)

Migrated from `chekimthoa.com` backup. Runs as a Docker Compose stack on this machine, exposed via Cloudflare tunnel.

**Stack:** PHP 8.3 + Apache (official `wordpress` image) + MySQL 8.0

**Theme:** `wp-content/themes/chekimthoa-theme/` ← edit here  
**Plugins:** `wp-content/plugins/` (WooCommerce, Flatsome, CF7, RankMath, etc.)  
**Uploads:** Docker volume `ckt_uploads` (not in git, persists across deploys)  
**Database:** Docker volume `ckt_db_data`

**Config file:** `ckt/.env` (not committed — create from the table below on a new machine)

| Variable | Description |
|----------|-------------|
| `DB_NAME` | Database name |
| `DB_USER` | DB user |
| `DB_PASSWORD` | DB password |
| `DB_ROOT_PASSWORD` | MySQL root password |
| `WP_ENV` | `staging` or `production` |
| `WP_HOME` | Full URL e.g. `https://ckt.d4t0.com` |
| `AUTH_KEY` … `NONCE_SALT` | WordPress salts (generate at https://roots.io/salts.html) |

**WordPress admin:** user `quanly`, login at `https://ckt.d4t0.com/wp-admin`

#### Daily commands

```bash
cd /home/dat/Sources/0lab/ckt

# Start / stop
docker compose up -d
docker compose down

# View logs
docker compose logs -f wordpress

# Run WP-CLI
docker compose exec wordpress php wp-cli.phar <command> --allow-root

# Import a new DB backup
docker compose exec -T db mysql -u wordpress -pPASSWORD ckt_wordpress < backup.sql

# Search-replace domain after DB import
docker compose exec -T wordpress php wp-cli.phar \
  search-replace 'https://old-domain.com' 'https://ckt.d4t0.com' --allow-root
```

#### Deploy flow

```
Edit theme in VS Code
  → git add / commit
  → git push origin staging
  → GitHub Actions (deploy-ckt.yml) triggers
  → Runner: git pull + docker compose up -d --build
  → Live at https://ckt.d4t0.com
```

> Theme and plugin changes are **bind-mounted** — they reflect immediately after `git pull` without a Docker rebuild. Only changes to `Dockerfile` or `wp-config.php` require a rebuild.

#### Restore on a new machine

```bash
git clone git@github.com:dttad/0lab.git
cd 0lab/ckt

# Create .env (fill in values)
cp /path/to/backup/.env .env

# Start stack
docker compose up -d --build

# Import database
docker compose exec -T db mysql -u wordpress -pPASSWORD ckt_wordpress < backup.sql

# Copy uploads into volume
docker run --rm \
  -v ckt_uploads:/uploads \
  -v /path/to/backup/uploads:/src:ro \
  alpine sh -c "cp -r /src/. /uploads/"

# Search-replace domain if needed
docker compose exec -T wordpress php wp-cli.phar \
  search-replace 'https://old-domain.com' 'https://ckt.d4t0.com' --allow-root
```

---

### `sitemap/` — Sitemap crawler

CLI tool that fetches and parses XML sitemaps from websites, saving results as gzip-compressed JSON files. Useful for bulk URL extraction, SEO audits, and web indexing.

**Language:** Python 3.12  
**Base image:** `python:3.12-slim`  
**Registry image:** `localhost:5000/sitemap-crawler`

#### Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `URLS` | required | Comma-separated list of site URLs to crawl |
| `THRESHOLD` | `50000` | URLs per output file before splitting |
| `MOUNTED_OUTPUT_PATH` | `/opt/output` | Directory to write output files |

#### Output format

Files are named `{domain}_{batch}_{count}.json.gz` and contain:

```json
[
  {"url": "https://example.com/page", "last_modified": "2024-01-01T00:00:00"},
  ...
]
```

#### Run from registry

```bash
docker run --rm \
  -e URLS="https://example.com/" \
  -e THRESHOLD=50000 \
  -v $PWD/output:/opt/output \
  localhost:5000/sitemap-crawler:staging
```

#### Run multiple URLs in parallel (`prorun.sh`)

```bash
cd sitemap
bash prorun.sh -u "https://site1.com,https://site2.com" -o "/opt/output" -t 200000
```

Each URL gets its own container, all run in parallel.

#### Build flow

```
Edit sitemap/
  → git push origin staging (or main)
  → GitHub Actions (build-sitemap.yml) triggers
  → Runner: docker build → push to localhost:5000
  → Tags: :{git-sha} + :staging (or :latest on main)
```

#### GitHub Actions secrets required

| Secret | Value |
|--------|-------|
| `ZOT_USER` | `dat` |
| `ZOT_PASSWORD` | registry password |

---

## Adding a new project

1. Create a subdirectory: `mkdir 0lab/myproject`
2. Add a `Dockerfile` and whatever the project needs
3. Add a workflow at `.github/workflows/build-myproject.yml` with `paths: ['myproject/**']`
4. Push to `staging` or `main` — the self-hosted runner picks it up automatically

## Branch strategy

| Branch | Behaviour |
|--------|-----------|
| `staging` | Deploys CKT to `https://ckt.d4t0.com`; builds sitemap image tagged `:staging` |
| `main` | (future) Deploy to production; builds sitemap image tagged `:latest` |
