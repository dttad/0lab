docker run -d --rm \
    -e URLS="https://hypestat.com/,https://websiteoutlook.com/,https://webstatsdomain.org/" \
    -e MOUNTED_OUTPUT_PATH="/opt/output" \
    -e THRESHOLD=200000 \
    -v $PWD/output:/opt/output \
    --name="crawler_sitemap_apkcombo_$(date +%s)" \
    sitemap_crawler
