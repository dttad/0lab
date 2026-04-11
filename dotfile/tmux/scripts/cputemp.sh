#!/usr/bin/env bash

set -euo pipefail

temp="$(
  sensors 2>/dev/null | awk '
    /\+?[0-9]+(\.[0-9]+)?°C/ {
      match($0, /\+?[0-9]+(\.[0-9]+)?/)
      if (RSTART > 0) {
        value = substr($0, RSTART, RLENGTH)
        sum += value
        count++
      }
    }
    END {
      if (count > 0) {
        printf "%.0f", sum / count
      }
    }
  '
)"

if [[ -n "${temp}" ]]; then
  printf '%s°C\n' "${temp}"
else
  printf '%s\n' '--°C'
fi
