#!/usr/bin/env bash

set -euo pipefail

rpm="$(
  sensors 2>/dev/null | awk '
    /fan[0-9]*:/ || /cpu_fan:/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^[0-9]+$/) {
          print $i
          exit
        }
      }
    }
  '
)"

if [[ -n "${rpm}" ]]; then
  printf '%srpm\n' "${rpm}"
else
  printf '%s\n' '--rpm'
fi
