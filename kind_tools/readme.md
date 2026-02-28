# Kind Tools

Cluster setup script for kind, intended to be called from cluster setup scripts in `cluster_setups/`. Each cluster setup script sets a `CLUSTER_NAME` and any tool-specific variables, then delegates cluster creation here before calling `k8s_tools/` install scripts.

## Usage

Called from a `cluster_setups/<name>/start_<name>.sh` script:
```bash
CLUSTER_NAME="${CLUSTER_NAME}" bash "${ROOT_DIR}/kind_tools/cluster_setup.sh"
```

The script also accepts positional arguments for lifecycle management:
```bash
# Recreate cluster from scratch
bash cluster_setup.sh --clean

# Tear down only (no recreate)
bash cluster_setup.sh --clean --only
```

If the cluster already exists and `--clean` is not passed, the script exits with a warning rather than failing.

## Environment Variables

| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| `CLUSTER_NAME` | `kind` | Name of the kind cluster |
| `TOOLS_CONFIG_NAME` | _(unset)_ | Name of a config file inside `kind_tools/configs/` (e.g. `default-values.yaml`). Ignored if `KIND_CONFIG_FILE` is set. |
| `KIND_CONFIG_FILE` | _(unset)_ | Full path to a kind Cluster config YAML. Takes precedence over `TOOLS_CONFIG_NAME`. When neither is set, `configs/default-values.yaml` is used. |

## Default Config

`configs/default-values.yaml` defines a 3-node cluster:

- 1 control-plane node
  - `ingress-ready=true` label — marks this node as the ingress endpoint
  - Host port mappings pre-configured for the monitoring stack:
    | Host Port | Container Port | Service |
    | --------- | -------------- | ------- |
    | `30080` | `30080` | Grafana |
    | `30090` | `30090` | Prometheus |
    | `30093` | `30093` | Alertmanager |
- 2 worker nodes