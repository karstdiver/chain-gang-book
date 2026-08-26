#!/usr/bin/env bash
# validate.sh — broken-book checks for chain-gang-book
# Structural / asset integrity only (not prose or style linting).
# Placeholder: real checks will be added incrementally.
# Exit 0 for now so make validate does not block the workflow.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

echo "validate: placeholder — no broken-book checks implemented yet."
echo "  (Next: manifest paths, metadata, cover, images, Markdown structure traps.)"
echo "OK"
exit 0
