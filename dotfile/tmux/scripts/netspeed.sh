#!/usr/bin/env bash

set -euo pipefail

iface="${1:-}"

if [[ -z "${iface}" ]]; then
  iface="$(ip route show default 2>/dev/null | awk 'NR==1 {print $5}')"
fi

if [[ -z "${iface}" || ! -r /proc/net/dev ]]; then
  printf '%s\n' '---'
  exit 0
fi

prev_file="/tmp/tmux_net_${iface}"

read -r curr_rx curr_tx < <(
  awk -v iface="${iface}:" '$1 == iface {print $2, $10}' /proc/net/dev
)

if [[ -z "${curr_rx:-}" || -z "${curr_tx:-}" ]]; then
  printf '%s\n' '---'
  exit 0
fi

curr_time="$(date +%s%3N)"

fmt_speed() {
  local bytes_per_second="$1"
  if (( bytes_per_second >= 1073741824 )); then
    printf "%.1fGB" "$(echo "scale=1; ${bytes_per_second}/1073741824" | bc)"
  elif (( bytes_per_second >= 1048576 )); then
    printf "%.1fMB" "$(echo "scale=1; ${bytes_per_second}/1048576" | bc)"
  elif (( bytes_per_second >= 1024 )); then
    printf "%dKB" $((bytes_per_second / 1024))
  else
    printf "%dB" "${bytes_per_second}"
  fi
}

if [[ -f "${prev_file}" ]]; then
  read -r prev_rx prev_tx prev_time < "${prev_file}"
  elapsed_ms=$((curr_time - prev_time))

  if (( elapsed_ms > 200 && elapsed_ms < 30000 )); then
    rx_bps=$(((curr_rx - prev_rx) * 1000 / elapsed_ms))
    tx_bps=$(((curr_tx - prev_tx) * 1000 / elapsed_ms))

    (( rx_bps < 0 )) && rx_bps=0
    (( tx_bps < 0 )) && tx_bps=0

    printf "↓%s ↑%s\n" "$(fmt_speed "${rx_bps}")" "$(fmt_speed "${tx_bps}")"
  else
    printf '%s\n' '---'
  fi
else
  printf '%s\n' '---'
fi

printf '%s %s %s\n' "${curr_rx}" "${curr_tx}" "${curr_time}" > "${prev_file}"
