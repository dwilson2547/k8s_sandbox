# K8s Sandbox

This repository contains scripts and configurations for setting up local Kubernetes clusters with various tools and configurations for testing and learning purposes.

## Tech Stack

- **Cluster runtime:** [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker)
- **Package manager:** Helm
- **Shell:** Bash (`#!/usr/bin/env bash`)
- **Prerequisites:** `kind`, `kubectl`, `helm` must be on `$PATH`
- **OS target:** Linux

## Repository Structure

- `kind_tools/`: Manages kind cluster lifecycle. Called by cluster setup scripts — not invoked directly by users.
  - `cluster_setup.sh`: Creates (or recreates) a kind cluster. Accepts `--clean` (recreate) and `--clean --only` (teardown only) flags.
  - `configs/`: kind Cluster config YAML files (default is a 3-node cluster with pre-mapped host ports for monitoring).
  - `readme.md`: Full documentation for `cluster_setup.sh` usage and environment variables.
- `k8s_tools/`: Helm-based install scripts for individual Kubernetes tools. Each tool has its own subdirectory.
  - `cert-manager/`: Installs cert-manager.
  - `flink-operator/`: Installs the Flink Kubernetes operator.
  - `prometheus-grafana/`: Installs the Prometheus/Grafana monitoring stack.
  - `template/`: Starter template for adding a new tool (`install-template.sh` + `readme.md`).
- `cluster_setups/`: End-to-end cluster setup scripts. Each subdirectory is a self-contained sandbox environment.
  - `flink_sandbox/`: Flink sandbox cluster (cert-manager + flink-operator).
  - `monitoring_lab/`: Monitoring cluster (Prometheus + Grafana).
  - `template/`: Template for new cluster setups (`start_cluster.sh` + `teardown.sh`).
- `docs/`: Installation guides for prerequisites (kind, kubectl, helm, Docker, Go, etc.).

## Scripting Conventions

All shell scripts follow these patterns:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
```

- Always use `set -euo pipefail` — never omit it.
- Always derive `SCRIPT_DIR` and `ROOT_DIR` using the pattern above so scripts are location-independent.
- Use colour-coded logging helpers in `k8s_tools` install scripts:
  ```bash
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
  log()  { echo -e "${GREEN}[INFO]${NC} $*"; }
  warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
  err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }
  ```
- Every `k8s_tools` install script must include a preflight check for its required commands:
  ```bash
  for cmd in kind kubectl helm; do
    if ! command -v "$cmd" &>/dev/null; then
      err "$cmd is required but not found on PATH"
      exit 1
    fi
  done
  ```
- Pass configuration to scripts via environment variables with sensible defaults:
  ```bash
  CLUSTER_NAME="${CLUSTER_NAME:-my-cluster}"
  ```
- Scripts should be idempotent where possible — re-running should not fail if resources already exist.

## Workflows

### Adding a New Cluster Setup

1. Copy `cluster_setups/template/` to `cluster_setups/<name>/`.
2. In `start_cluster.sh`, set `CLUSTER_NAME` and replace the example tool install call(s) with the relevant `k8s_tools` scripts.
3. In `teardown.sh`, update `CLUSTER_NAME` to match.
4. Add a `readme.md` documenting the purpose and any environment variables.

The standard `start_cluster.sh` pattern is:

```bash
CLUSTER_NAME="${CLUSTER_NAME:-<name>}" bash "${ROOT_DIR}/kind_tools/cluster_setup.sh"
bash "${ROOT_DIR}/k8s_tools/<tool>/install-<tool>.sh"
```

### Adding a New K8s Tool

1. Copy `k8s_tools/template/` to `k8s_tools/<tool-name>/`.
2. Implement `install-<tool-name>.sh` following the template (preflight checks, colour logging, Helm install).
3. Fill in `readme.md` using the template structure (description, dependencies, env vars, Helm values, usage).

### kind_tools/cluster_setup.sh Flags

| Invocation | Behaviour |
|---|---|
| `bash cluster_setup.sh` | Create cluster if it doesn't exist; skip if it does |
| `bash cluster_setup.sh --clean` | Delete existing cluster and recreate |
| `bash cluster_setup.sh --clean --only` | Delete existing cluster, do not recreate |
