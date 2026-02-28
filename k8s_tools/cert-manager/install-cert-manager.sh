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
for cmd in kubectl; do
  if ! command -v "$cmd" &>/dev/null; then
    err "$cmd is required but not found on PATH"
    exit 1
  fi
done

# --- Install cert-manager (required by Flink operator) ---
log "Installing cert-manager..."
kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml

log "Waiting for cert-manager to be ready..."
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=120s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=120s
kubectl -n cert-manager rollout status deployment/cert-manager-cainjector --timeout=120s

# --- Verify ---
echo ""
log "========================================="
log " Cert-manager is ready!"
log "========================================="
echo ""