#!/usr/bin/env bash
set -euo pipefail

asset="assets/db/ARC.db"
expected_sha256="e8efc828da248d896edd2b1d624aa620f370d6948766026bb4b25fcfcdc5c0c2"
expected_size="4575232"

actual_sha256="$(sha256sum "$asset" | awk '{print $1}')"
actual_size="$(stat -c '%s' "$asset")"

if [[ "$actual_sha256" != "$expected_sha256" || "$actual_size" != "$expected_size" ]]; then
  printf 'ARC.db integrity check failed: expected %s/%s, got %s/%s\n' \
    "$expected_sha256" "$expected_size" "$actual_sha256" "$actual_size" >&2
  exit 1
fi

echo "Verified $asset ($actual_size bytes, SHA-256 $actual_sha256)."
