# Monitoring Lab

### Tool Dependencies:
- [x] prometheus-grafana

### Cluster Configuration
- Default - 3 node
- Name: monitoring-lab

### Env Overrides
- `CLUSTER_NAME`: monitoring-lab
- `NAMESPACE`: monitoring
- `PROMETHEUS_VALUES_FILE`: k8s_tools/prometheus-grafana/values.yaml

### Custom Additions
N/A

### Intended Use
- Local Kubernetes monitoring stack using `kube-prometheus-stack`
  - Prometheus — metrics collection with 7d retention
  - Grafana — dashboards and visualization (pre-loaded with K8s dashboards)
  - Alertmanager — alert routing and notification
  - Node Exporter — host-level metrics
  - Kube State Metrics — Kubernetes object state metrics

### Quick Start
```bash
bash start_prometheus_cluster.sh
```

### Access

| Service | URL | Credentials |
|---------|-----|-------------|
| Grafana | http://grafana.127.0.0.1.nip.io | admin / admin |
| Prometheus | http://prometheus.127.0.0.1.nip.io | — |
| Alertmanager | http://alertmanager.127.0.0.1.nip.io | — |

### Teardown
```bash
bash teardown.sh
```

### Adding Your Own ServiceMonitor
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
    - port: metrics
      interval: 15s
```
