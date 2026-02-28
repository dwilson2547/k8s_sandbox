#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTER_NAME="monitoring-lab"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
step()  { echo -e "${CYAN}[STEP]${NC} $*"; }

# ── Pre-flight checks ──────────────────────────────────────────────
for cmd in kind kubectl helm; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: '$cmd' is required but not installed."
    exit 1
  fi
done

# ── Step 1: Create kind cluster ────────────────────────────────────
step "1/4 Creating kind cluster '${CLUSTER_NAME}' (1 control-plane + 2 workers)..."

if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
  warn "Cluster '${CLUSTER_NAME}' already exists. Skipping creation."
else
  kind create cluster --config "${SCRIPT_DIR}/kind-cluster.yaml"
  info "Cluster created."
fi

kubectl cluster-info --context "kind-${CLUSTER_NAME}"
echo ""

# ── Step 2: Wait for nodes ─────────────────────────────────────────
step "2/4 Waiting for all nodes to be Ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s
echo ""
kubectl get nodes -o wide
echo ""

# ── Step 3: Add Helm repos ─────────────────────────────────────────
step "3/4 Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update
echo ""

# ── Step 4: Install kube-prometheus-stack ──────────────────────────
step "4/4 Installing kube-prometheus-stack..."

NAMESPACE="monitoring"
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace "${NAMESPACE}" \
  --values "${SCRIPT_DIR}/values-kube-prometheus-stack.yaml" \
  --version 72.6.2 \
  --wait \
  --timeout 10m

echo ""
info "Installation complete!"
echo ""

# ── Summary ────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e " ${GREEN}✔ Monitoring Stack Ready${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo " Grafana:      http://localhost:30080  (admin / admin)"
echo " Prometheus:   http://localhost:30090"
echo " Alertmanager: http://localhost:30093"
echo ""
echo " Useful commands:"
echo "   kubectl -n ${NAMESPACE} get pods"
echo "   kubectl -n ${NAMESPACE} get servicemonitors"
echo "   kubectl -n ${NAMESPACE} get prometheusrules"
echo ""
echo " To tear down:"
echo "   kind delete cluster --name ${CLUSTER_NAME}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"