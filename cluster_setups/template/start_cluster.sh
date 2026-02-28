#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# TODO: Update cluster name
CLUSTER_NAME="${CLUSTER_NAME:-cluster-name}"

CLUSTER_NAME="${CLUSTER_NAME}" bash "${ROOT_DIR}/kind_tools/cluster_setup.sh"
# TODO: Update with additional tools to install, remove example
bash "${ROOT_DIR}/k8s_tools/../example.sh"
