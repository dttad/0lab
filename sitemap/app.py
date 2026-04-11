import gzip
import json
import logging
import os
from datetime import datetime
from urllib.parse import urlparse

from usp.tree import sitemap_tree_for_homepage

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
log = logging.getLogger(__name__)

THRESHOLD = int(os.getenv("THRESHOLD", 50_000))
OUTPUT_PATH = os.getenv("MOUNTED_OUTPUT_PATH", "/opt/output")


def parse_domain(url: str) -> str:
    return urlparse(url).hostname


def write_batch(data: list[dict], path: str) -> None:
    payload = json.dumps(data, default=str).encode()
    with gzip.open(path, "wb") as f:
        f.write(payload)
    log.info("Saved %d records → %s", len(data), path)


def process_url(url: str) -> None:
    domain = parse_domain(url)
    log.info("Processing %s", domain)

    tree = sitemap_tree_for_homepage(url)

    batch: list[dict] = []
    batch_num = 0

    for page in tree.all_pages():
        lm = page.last_modified
        batch.append({
            "url": page.url,
            "last_modified": lm.isoformat() if isinstance(lm, datetime) else lm,
        })

        if len(batch) >= THRESHOLD:
            path = f"{OUTPUT_PATH}/{domain}_{batch_num}_{len(batch)}.json.gz"
            write_batch(batch, path)
            batch = []
            batch_num += 1

    # Save remaining
    if batch:
        path = f"{OUTPUT_PATH}/{domain}_{batch_num}_{len(batch)}.json.gz"
        write_batch(batch, path)


def run() -> None:
    raw = os.getenv("URLS", "")
    if not raw.strip():
        raise ValueError("URLS env var is required and cannot be empty")

    urls = [u.strip() for u in raw.split(",") if u.strip()]

    for url in urls:
        try:
            process_url(url)
        except Exception:
            log.exception("Failed to process %s", url)


if __name__ == "__main__":
    run()
