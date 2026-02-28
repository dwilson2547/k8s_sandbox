#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

CLUSTER_NAME="${CLUSTER_NAME:-flink-sandbox}"

CLUSTER_NAME="${CLUSTER_NAME}" bash "${ROOT_DIR}/kind_tools/cluster_setup.sh"

bash "${ROOT_DIR}/k8s_tools/cert-manager/install-cert-manager.sh"
bash "${ROOT_DIR}/k8s_tools/flink-operator/install-flink-operator.sh"
# bash "${ROOT_DIR}/k8s_tools/prometheus-grafana/install-prometheus-grafana.sh"
