#!/bin/bash
set -euo pipefail
# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# --- Preflight checks ---
for cmd in kind kubectl helm; do
  if ! command -v "$cmd" &>/dev/null; then
    err "$cmd is required but not found on PATH"
    exit 1
  fi
done

