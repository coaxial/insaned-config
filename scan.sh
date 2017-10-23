#!/usr/bin/env bash
set -euo pipefail

scripts_root="./etc/insaned/events"
pages_scanned=0
orientation=p

while true; do

  read -r -p "l to toggle orientation ($orientation), s to scan, c to combine, o for single page, b for batch, q to quit " -s -n 1 input
  echo "$input"

  if [[ $input = "l" ]]; then
    if [[ $orientation = "p" ]]; then
      orientation=l
    else
      orientation=p
    fi

    echo "switching to $orientation"
  fi
  if [[ $input = "s" ]]; then
    echo "scanning page..."
    PAGE_ORIENTATION="$orientation" "$scripts_root"/file
    pages_scanned=$((pages_scanned +1))
    echo "ok"
  fi

  if [[ $input = "c" ]]; then
    echo "combining pages..."
    "$scripts_root"/extra
    echo "ok"
  fi

  if [[ $input = "o" ]]; then
    echo "scanning one page document..."
    PAGE_ORIENTATION="$orientation" "$scripts_root"/file
    pages_scanned=$((pages_scanned +1))
    "$scripts_root"/extra
    echo "ok"
  fi

  if [[ $input = "b" ]]; then
    echo "batch mode scanning..."
    BATCH_MODE=true "$scripts_root"/file
    "$scripts_root"/extra
  fi

  if [[ $input = "q" ]]; then
    echo "scanned $pages_scanned pages (excluding batch mode)"
    break
  fi
done
