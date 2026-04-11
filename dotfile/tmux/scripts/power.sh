#!/usr/bin/env bash

set -euo pipefail

if [[ -f /tmp/turbostat_watts ]]; then
  read -r watts < /tmp/turbostat_watts
  printf "%.0fW\n" "${watts}"
else
  printf '%s\n' '--W'
fi
