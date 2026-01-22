#!/usr/bin/env bash
# Ensure no "nyldn" references remain in the repo or fixtures

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Running legacy-owner safeguard test..."

# Should fail when nyldn appears in the target root
mkdir -p "$TMP_DIR/subdir"
printf '%s\n' "owned by nyldn" > "$TMP_DIR/subdir/has-nyldn.txt"

if "$PROJECT_ROOT/tests/validate-no-legacy-owner.sh" "$TMP_DIR" >/dev/null 2>&1; then
  echo "Expected failure when nyldn exists, but validation passed."
  exit 1
fi

# Clear visible nyldn before hidden-path check
rm -f "$TMP_DIR/subdir/has-nyldn.txt"

# Should fail when nyldn appears in hidden directories
mkdir -p "$TMP_DIR/.hidden"
printf '%s\n' "nyldn hidden" > "$TMP_DIR/.hidden/has-nyldn.txt"

if "$PROJECT_ROOT/tests/validate-no-legacy-owner.sh" "$TMP_DIR" >/dev/null 2>&1; then
  echo "Expected failure when nyldn exists in hidden paths, but validation passed."
  exit 1
fi

# Should pass when nyldn does not appear
rm -f "$TMP_DIR/.hidden/has-nyldn.txt"
printf '%s\n' "owned by hihidev" > "$TMP_DIR/subdir/clean.txt"

if ! "$PROJECT_ROOT/tests/validate-no-legacy-owner.sh" "$TMP_DIR" >/dev/null 2>&1; then
  echo "Expected success when nyldn is absent, but validation failed."
  exit 1
fi

echo "Legacy-owner safeguard test passed."
