#!/usr/bin/env bash
set -euo pipefail

build_file="android/app/build.gradle"

grep -q 'applicationId = "dev.roseno.biblia"' "$build_file"
grep -q 'signingConfigs {' "$build_file"
grep -q 'signingConfig = hasReleaseSigning ? signingConfigs.release : signingConfigs.debug' "$build_file"
if grep -q 'signingConfig = signingConfigs.debug' "$build_file"; then
  echo 'Release signing must not unconditionally use the debug keystore.' >&2
  exit 1
fi

echo 'Android application ID and release signing policy are configured.'
