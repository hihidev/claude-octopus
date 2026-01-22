#!/usr/bin/env bash
# Fail if any "nyldn" references remain in the repository

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_ROOT="${1:-$PROJECT_ROOT}"

if rg -n "nyldn" "$TARGET_ROOT" --hidden \
  --glob '!.git' \
  --glob '!node_modules' \
  --glob '!dist' \
  --glob '!build' \
  --glob '!tests/validate-no-legacy-owner.sh' \
  --glob '!tests/test-no-legacy-owner.sh' \
  --glob '!tests/run-all-tests.sh' >/dev/null 2>&1; then
  echo "❌ Found forbidden 'nyldn' references:"
  rg -n "nyldn" "$TARGET_ROOT" --hidden \
    --glob '!.git' \
    --glob '!node_modules' \
    --glob '!dist' \
    --glob '!build' \
    --glob '!tests/validate-no-legacy-owner.sh' \
    --glob '!tests/test-no-legacy-owner.sh' \
    --glob '!tests/run-all-tests.sh'
  exit 1
fi

echo "✅ No 'nyldn' references found."
