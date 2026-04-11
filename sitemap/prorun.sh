#!/bin/bash

# Parse command line arguments
while getopts u:o:t: flag
do
    case "${flag}" in
        u) URLS=${OPTARG};;
        o) MOUNTED_OUTPUT_PATH=${OPTARG};;
        t) THRESHOLD=${OPTARG};;
    esac
done

# Split URLS by comma
IFS=',' read -ra URLS_ARRAY <<< "$URLS"

# Loop through each URL and run docker container
for URL in "${URLS_ARRAY[@]}"
do
    # Generate container name based on URL
    CONTAINER_NAME="crawler_$(echo "$URL" | sed 's/http[s]*:\/\/\|www\|[^a-zA-Z0-9]/_/g')_$(date +%s)"

    # Run docker container
    docker run -d --rm \
        -e URLS="$URL" \
        -e MOUNTED_OUTPUT_PATH="$MOUNTED_OUTPUT_PATH" \
        -e THRESHOLD="$THRESHOLD" \
        -v $PWD/output:/opt/output \
        --name="$CONTAINER_NAME" \
        sitemap_crawler

    # Print container name and URL
    echo "Started container $CONTAINER_NAME for URL: $URL"
done
# bash prorun.sh -u "https://tiki.vn" -o "/opt/output" -t 500000
