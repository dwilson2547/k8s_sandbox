#!/bin/bash
set -euo pipefail

CLUSTER_NAME="flink-sandbox"
FLINK_OPERATOR_VERSION="1.14.0"
FLINK_OPERATOR_NAMESPACE="flink-operator"
FLINK_JOBS_NAMESPACE="flink-jobs"

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
kind create cluster --config "${SCRIPT_DIR}/kind-config.yaml"

log "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# --- Install cert-manager (required by Flink operator) ---
log "Installing cert-manager..."
kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml

log "Waiting for cert-manager to be ready..."
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=120s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=120s
kubectl -n cert-manager rollout status deployment/cert-manager-cainjector --timeout=120s

# --- Install Flink Kubernetes Operator ---
log "Adding Flink Helm repo..."
helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-${FLINK_OPERATOR_VERSION}/
helm repo update

log "Installing Flink Kubernetes Operator v${FLINK_OPERATOR_VERSION}..."
kubectl create namespace "$FLINK_OPERATOR_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$FLINK_JOBS_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

log "Ensuring service account 'flink' exists in namespace '$FLINK_JOBS_NAMESPACE'..."
kubectl -n "$FLINK_JOBS_NAMESPACE" create serviceaccount flink --dry-run=client -o yaml | kubectl apply -f -

helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator \
  --namespace "$FLINK_OPERATOR_NAMESPACE" \
  --set webhook.create=true \
  --wait --timeout 180s

log "Waiting for Flink operator to be ready..."
kubectl -n "$FLINK_OPERATOR_NAMESPACE" rollout status deployment/flink-kubernetes-operator --timeout=120s

# --- Verify ---
echo ""
log "========================================="
log " Cluster is ready!"
log "========================================="
echo ""
kubectl get nodes -o wide
echo ""
kubectl -n "$FLINK_OPERATOR_NAMESPACE" get pods
echo ""
log "Namespaces:"
log "  Operator: $FLINK_OPERATOR_NAMESPACE"
log "  Jobs:     $FLINK_JOBS_NAMESPACE"
log ""
log "To deploy a Flink job:"
log "  kubectl apply -f my-flink-job.yaml -n $FLINK_JOBS_NAMESPACE"
log ""
log "To access Flink UI (after deploying a job):"
log "  kubectl port-forward svc/<job-name>-rest 8081:8081 -n $FLINK_JOBS_NAMESPACE"
log ""
log "To tear down:"
log "  $0 --clean --only"