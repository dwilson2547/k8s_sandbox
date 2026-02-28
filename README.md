# k8s_sandbox

A local Kubernetes sandbox built on [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker). Contains reusable cluster setup scripts and Helm-based tool installers for spinning up self-contained environments for testing and learning.

## Prerequisites

| Tool | Purpose |
|------|---------|
| [kind](docs/install_kind.md) | Runs Kubernetes clusters inside Docker containers |
| [kubectl](docs/install_kubectl.md) | Kubernetes CLI |
| [helm](https://helm.sh/docs/intro/install/) | Package manager for Kubernetes |
| [Docker](docs/install_docker.md) | Container runtime required by kind |

See the [docs/](docs/) directory for full installation guides, including [Go](docs/install_go.md), [nerdctl](docs/install_nerdctl.md), and [Podman](docs/install_podman.md).

## Repository Structure

```
k8s_sandbox/
├── kind_tools/          # kind cluster lifecycle management
├── k8s_tools/           # Helm-based install scripts for individual tools
├── cluster_setups/      # End-to-end sandbox environments
└── docs/                # Prerequisite installation guides
```

## Cluster Setups

Each subdirectory in `cluster_setups/` is a self-contained environment with its own `start_*.sh` and `teardown.sh` scripts.

| Setup | Description | Docs |
|-------|-------------|------|
| `monitoring_lab` | Prometheus, Grafana, Alertmanager, Node Exporter, kube-state-metrics | [readme](cluster_setups/monitoring_lab/readme.md) |
| `flink_sandbox` | Apache Flink Kubernetes Operator with example job manifest | [readme](cluster_setups/flink_sandbox/readme.md) |

### Quick Start (any setup)

```bash
cd cluster_setups/<setup-name>
bash start_<setup-name>.sh

# Tear down when done
bash teardown.sh
```

## K8s Tools

Reusable install scripts in `k8s_tools/` can be composed into any cluster setup.

| Tool | Description | Docs |
|------|-------------|------|
| `prometheus-grafana` | kube-prometheus-stack (Prometheus, Grafana, Alertmanager) | [readme](k8s_tools/prometheus-grafana/readme.md) |
| `cert-manager` | Certificate management for Kubernetes | [readme](k8s_tools/cert-manager/readme.md) |
| `flink-operator` | Apache Flink Kubernetes Operator (requires cert-manager) | [readme](k8s_tools/flink-operator/readme.md) |

## Kind Tools

`kind_tools/cluster_setup.sh` handles cluster creation and is called internally by all cluster setup scripts. See the [kind_tools readme](kind_tools/readme.md) for full documentation on flags, environment variables, and the default cluster configuration.

## Adding a New Setup or Tool

- **New cluster setup:** copy `cluster_setups/template/` and update `CLUSTER_NAME` and tool install calls.
- **New k8s tool:** copy `k8s_tools/template/` and implement the install script and readme.

Refer to [.github/copilot-instructions.md](.github/copilot-instructions.md) for scripting conventions and workflow details.