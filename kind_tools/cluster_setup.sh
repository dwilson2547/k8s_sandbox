#!/bin/bash
set -eu pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }

CLUSTER_NAME="${CLUSTER_NAME:-kind}"
VALUES_FILE="${VALUES_FILE:-${SCRIPT_DIR}/configs/default-values.yaml}"

# --- Preflight checks ---
for cmd in kind; do
  if ! command -v "$cmd" &>/dev/null; then
    err "$cmd is required but not found on PATH"
    exit 1
  fi
done

# --- Cleanup existing cluster if requested ---
if [[ "${1:-}" == "--clean" ]]; then
  log "Deleting existing cluster '$CLUSTER_NAME'..."
  kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null || true
  log "Cleanup complete."
  [[ "${2:-}" == "--only" ]] && exit 0
fi

# --- Check if cluster already exists ---
if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
  warn "Cluster '$CLUSTER_NAME' already exists. Use --clean to recreate."
  exit 0
fi

# --- Create cluster ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log "Creating Kind cluster '$CLUSTER_NAME' (1 control-plane + 2 workers)..."
kind create cluster --config "${VALUES_FILE}" --name "${CLUSTER_NAME}"

log "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# --- Verify ---
echo ""
log "========================================="
log " Cluster is ready!"
log "========================================="
echo ""

log "To tear down:"
log "  $0 --clean --only"