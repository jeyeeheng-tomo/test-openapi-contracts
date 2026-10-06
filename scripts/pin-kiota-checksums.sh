#!/usr/bin/env bash
# Prints the sha256 of every Kiota release asset we support, for pasting into
# codegen.json under dart.kiotaChecksums. GitHub publishes no checksums itself.
#
# Usage: ./scripts/pin-kiota-checksums.sh 1.35.0
set -euo pipefail
version="${1:?usage: $0 <kiota-version>}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

declare -A assets=(
  [darwin-arm64]=osx-arm64
  [darwin-x64]=osx-x64
  [linux-x64]=linux-x64
  [linux-arm64]=linux-arm64
)

for key in "${!assets[@]}"; do
  asset="${assets[$key]}"
  curl -sL -o "$tmp/$asset.zip" \
    "https://github.com/microsoft/kiota/releases/download/v${version}/${asset}.zip"
  printf '  "%s": "%s",\n' "$key" "$(shasum -a 256 "$tmp/$asset.zip" | cut -d' ' -f1)"
done
