#!/usr/bin/env bash

set -euo pipefail

bar_len="${1:-10}"

read -r total used < <(free -b | awk '/Mem:/ {print $2, $3}')

pct=$((used * 100 / total))
filled=$(((pct * bar_len + 50) / 100))
empty=$((bar_len - filled))

bar=""
for ((i = 0; i < filled; i++)); do
  bar+="█"
done
for ((i = 0; i < empty; i++)); do
  bar+="░"
done

printf "%s %d%% (%.1f/%.1fG)" "${bar}" "${pct}" \
  "$(echo "scale=1; ${used}/1073741824" | bc)" \
  "$(echo "scale=1; ${total}/1073741824" | bc)"
