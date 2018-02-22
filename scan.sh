#!/usr/bin/env bash
set -euo pipefail

scripts_root="./etc/insaned/events"
trimmer_location="./usr/local/lib/trimmer"
pages_scanned=0
orientation=p # p or l
doc_type="ocr" # photo or ocr
trimEnabled=1 # for photo only

while true; do
  prompt="d to change document type ($doc_type), l to toggle orientation ($orientation), s to scan, c to combine, o for single page, b for batch, q to quit "

  if [[ $doc_type = "photo" ]]; then
    prompt="d to change document type ($doc_type), t to toggle trimming ($trimEnabled), o to scan, q to quit "
  fi

  read -r -p "$prompt" -s -n 1 input
  echo "$input"

  if [[ $input = "d" ]]; then
    if [[ $doc_type = "ocr" ]]; then
      doc_type="photo"
    else
      doc_type="ocr"
    fi
  fi

  if [[ $doc_type = "photo" ]]; then
    if [[ $input = "t" ]]; then
      trimEnabled=$((trimEnabled==0))
    fi

    if [[ $input = "o" ]]; then
      checktrim() {
        outfile_size=$(ls -s /tmp/scan_trimmed.pnm | cut -f1 -d " ")
        # the trim fails sometimes and we end up with an empty file (i.e. a 4KB
        # file)
        if [[ "$outfile_size" = 4 ]]; then
          echo "trimming failed, will rescan..."
          getphoto
        fi
      }
      getphoto() {
        scanimage \
          -p \
          --resolution 600 \
          --mode color \
          > /tmp/scan.pnm
        echo ""
        doTrim
      }
      doTrim() {
        if [[ $trimEnabled ]]; then
          "$trimmer_location" -s "east,south" -f 91 /tmp/scan.pnm /tmp/scan_trimmed.pnm
          checktrim
        fi
      }

      getphoto
      convert /tmp/scan_trimmed.pnm "$HOME/Documents/scans/photo_$(date "+%Y%m%d_%H%M%S").png"
      pages_scanned=$((pages_scanned +1))
      echo "ok"
    fi
  fi

  if [[ $doc_type = "ocr" ]]; then
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
  fi

  if [[ $input = "q" ]]; then
    echo "scanned $pages_scanned pages (excluding batch mode)"
    break
  fi
done
