# Prometheus + Grafana (kube-prometheus-stack)

### Description
Installs the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) Helm chart, which bundles Prometheus, Grafana, Alertmanager, Node Exporter, and kube-state-metrics. Ingress routes are configured for local development using `nip.io` domains backed by an nginx ingress controller.

Default endpoints (after install):
| Service | URL |
| ------- | --- |
| Grafana | http://grafana.127.0.0.1.nip.io (admin / admin) |
| Prometheus | http://prometheus.127.0.0.1.nip.io |
| Alertmanager | http://alertmanager.127.0.0.1.nip.io |

### Dependencies:
- [ ] nginx ingress controller

### Environment Variables
| Variable Name | Description | Default Value |
| ------------- | ----------- | ------------- |
| `NAMESPACE` | Namespace to install the stack into | `monitoring` |
| `PROMETHEUS_VALUES_FILE` | Path to a custom Helm values override file | `values.yaml` (co-located with the script) |

### Helm Values (If Applicable)
`values.yaml` is included in this directory and is used by default. Key settings:

| Key | Description | Default |
| --- | ----------- | ------- |
| `grafana.adminUser` / `grafana.adminPassword` | Grafana admin credentials | `admin` / `admin` |
| `prometheus.prometheusSpec.retention` | Metrics retention period | `7d` |
| `prometheus.prometheusSpec.retentionSize` | Max storage size | `5GB` |
| `prometheus.prometheusSpec.storageSpec` | Storage backend (emptyDir by default; use a PVC for production) | `{}` |

### Usage
Called from a cluster setup start script:
```bash
bash "${ROOT_DIR}/k8s_tools/prometheus-grafana/install-prometheus-grafana.sh"

# With variable overrides
NAMESPACE=observability PROMETHEUS_VALUES_FILE=/path/to/my-values.yaml \
  bash "${ROOT_DIR}/k8s_tools/prometheus-grafana/install-prometheus-grafana.sh"
```

Useful post-install commands:
```bash
kubectl -n monitoring get pods
kubectl -n monitoring get servicemonitors
kubectl -n monitoring get prometheusrules
```
