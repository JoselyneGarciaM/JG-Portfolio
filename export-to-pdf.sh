#!/bin/bash
# Converts all JG Portfolio HTML files to PDF using Chrome headless
# Run from Terminal: bash export-to-pdf.sh
# Or double-click after running: chmod +x export-to-pdf.sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [ ! -f "$CHROME" ]; then
  echo "Chrome not found at expected path. Trying alternatives..."
  CHROME="/Applications/Chromium.app/Contents/MacOS/Chromium"
fi

if [ ! -f "$CHROME" ]; then
  echo "Error: Could not find Chrome or Chromium. Please install Google Chrome."
  exit 1
fi

echo "Using: $CHROME"
echo "Exporting PDFs to: $DIR"
echo ""

FILES=("portfolio.html" "cover-risk-scan.html" "cover-system-build.html" "cover-fractional.html")

for f in "${FILES[@]}"; do
  INPUT="$DIR/$f"
  OUTPUT="$DIR/${f%.html}.pdf"

  if [ ! -f "$INPUT" ]; then
    echo "⚠️  Skipping $f — file not found"
    continue
  fi

  echo "Converting $f..."
  "$CHROME" \
    --headless \
    --disable-gpu \
    --no-sandbox \
    --print-to-pdf="$OUTPUT" \
    --print-to-pdf-no-header \
    --no-pdf-header-footer \
    "file://$INPUT" 2>/dev/null

  if [ -f "$OUTPUT" ]; then
    echo "✅  $OUTPUT"
  else
    echo "❌  Failed: $OUTPUT"
  fi
done

echo ""
echo "Done! Open Finder to see your PDF files."
open "$DIR"
