#!/usr/bin/env bash

set -euo pipefail

bar_len="${1:-10}"
prev_file="/tmp/tmux_cpu_prev"

read -r _ user nice sys idle iowait irq softirq _ < <(
  awk '/^cpu / {print $1, $2, $3, $4, $5, $6, $7, $8, $9}' /proc/stat
)

prev_idle=0
prev_total=0
if [[ -f "${prev_file}" ]]; then
  read -r prev_idle prev_total < "${prev_file}"
fi

total=$((user + nice + sys + idle + iowait + irq + softirq))
diff_idle=$((idle - prev_idle))
diff_total=$((total - prev_total))

printf '%s %s\n' "${idle}" "${total}" > "${prev_file}"

if (( diff_total > 0 )); then
  pct=$(((diff_total - diff_idle) * 100 / diff_total))
else
  pct=0
fi

filled=$(((pct * bar_len + 50) / 100))
empty=$((bar_len - filled))

bar=""
for ((i = 0; i < filled; i++)); do
  bar+="█"
done
for ((i = 0; i < empty; i++)); do
  bar+="░"
done

printf "%s %d%%" "${bar}" "${pct}"
