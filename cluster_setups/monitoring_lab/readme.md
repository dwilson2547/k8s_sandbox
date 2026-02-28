# Kind + Prometheus Operator + Grafana

Local Kubernetes monitoring stack using kind, kube-prometheus-stack Helm chart.

## Cluster Layout

| Node | Role |
|------|------|
| monitoring-lab-control-plane | Control plane |
| monitoring-lab-worker | Worker |
| monitoring-lab-worker2 | Worker |

## What Gets Installed

The `kube-prometheus-stack` Helm chart deploys:

- **Prometheus Operator** — manages Prometheus instances via CRDs
- **Prometheus** — metrics collection with 7d retention
- **Grafana** — dashboards and visualization (pre-loaded with K8s dashboards)
- **Alertmanager** — alert routing and notification
- **Node Exporter** — host-level metrics from each node
- **Kube State Metrics** — Kubernetes object state metrics
- **Default recording & alerting rules** — out-of-the-box K8s alerts

## Quick Start

```bash
chmod +x setup.sh teardown.sh
./setup.sh
```

## Access

| Service | URL | Credentials |
|---------|-----|-------------|
| Grafana | http://localhost:30080 | admin / admin |
| Prometheus | http://localhost:30090 | — |
| Alertmanager | http://localhost:30093 | — |

## Adding Your Own ServiceMonitor

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

The values file sets `serviceMonitorSelectorNilUsesHelmValues: false`, so Prometheus will pick up ServiceMonitors from **any namespace** without needing extra label selectors.

## Teardown

```bash
./teardown.sh
```
