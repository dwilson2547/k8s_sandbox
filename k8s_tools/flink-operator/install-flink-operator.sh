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

# Env variable defaults if not set
FLINK_OPERATOR_VERSION="${FLINK_OPERATOR_VERSION:-1.14.0}"
FLINK_OPERATOR_NAMESPACE="${FLINK_OPERATOR_NAMESPACE:-flink-operator}"
FLINK_JOBS_NAMESPACE="${FLINK_JOBS_NAMESPACE:-flink-jobs}"
FLINK_SERVICE_ACCOUNT="${FLINK_SERVICE_ACCOUNT:-flink}"

# --- Preflight checks ---
for cmd in kubectl helm; do
  if ! command -v "$cmd" &>/dev/null; then
    err "$cmd is required but not found on PATH"
    exit 1
  fi
done

# --- Install Flink Kubernetes Operator ---
log "Adding Flink Helm repo..."
helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-${FLINK_OPERATOR_VERSION}/
helm repo update

log "Installing Flink Kubernetes Operator v${FLINK_OPERATOR_VERSION}..."
kubectl create namespace "$FLINK_OPERATOR_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$FLINK_JOBS_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

log "Ensuring service account '$FLINK_SERVICE_ACCOUNT' exists in namespace '$FLINK_JOBS_NAMESPACE'..."
kubectl -n "$FLINK_JOBS_NAMESPACE" create serviceaccount "$FLINK_SERVICE_ACCOUNT" --dry-run=client -o yaml | kubectl apply -f -

helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator \
  --namespace "$FLINK_OPERATOR_NAMESPACE" \
  --set webhook.create=true \
  --wait --timeout 180s

log "Waiting for Flink operator to be ready..."
kubectl -n "$FLINK_OPERATOR_NAMESPACE" rollout status deployment/flink-kubernetes-operator --timeout=120s

# --- Verify ---
echo ""
log "========================================="
log " Flink operator is ready!"
log "========================================="
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
