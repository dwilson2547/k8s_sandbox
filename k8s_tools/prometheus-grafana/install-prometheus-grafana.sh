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

NAMESPACE="${NAMESPACE:-monitoring}"
PROMETHEUS_VALUES_FILE="${PROMETHEUS_VALUES_FILE:-${SCRIPT_DIR}/values.yaml}"

if [[ "${PROMETHEUS_VALUES_FILE}" != /* ]]; then
  PROMETHEUS_VALUES_FILE="${PWD}/${PROMETHEUS_VALUES_FILE}"
fi

if [[ ! -f "${PROMETHEUS_VALUES_FILE}" ]]; then
  err "Values file not found: ${PROMETHEUS_VALUES_FILE}"
  err "Set PROMETHEUS_VALUES_FILE to a valid override path, or use default: ${SCRIPT_DIR}/values.yaml"
  exit 1
fi

# --- Preflight checks ---
for cmd in kubectl helm; do
  if ! command -v "$cmd" &>/dev/null; then
    err "$cmd is required but not found on PATH"
    exit 1
  fi
done

# --- Add Helm repos ---
log "Adding Prometheus Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update
echo ""

# --- Install kube-prometheus-stack ---
log "Installing kube-prometheus-stack..."
log "Using values file: ${PROMETHEUS_VALUES_FILE}"

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace "${NAMESPACE}" \
  --values "${PROMETHEUS_VALUES_FILE}" \
  --version 72.6.2 \
  --wait \
  --timeout 10m

echo ""
log "Installation complete!"
echo ""

# --- Summary ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "✔ Monitoring Stack Ready"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
log " Grafana:      http://grafana.127.0.0.1.nip.io  (admin / admin)"
log " Prometheus:   http://prometheus.127.0.0.1.nip.io"
log " Alertmanager: http://alertmanager.127.0.0.1.nip.io"
echo ""
log " Useful commands:"
log "  kubectl -n ${NAMESPACE} get pods"
log "  kubectl -n ${NAMESPACE} get servicemonitors"
log "  kubectl -n ${NAMESPACE} get prometheusrules"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"