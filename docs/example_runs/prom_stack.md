# Monitorong Lab cluster example run

## Start Cluster
```bash
user@HOST:~/k8s_sandbox/cluster_setups/monitoring_lab$ ./start_prometheus_cluster.sh
```

### Output
```bash
[INFO] Creating Kind cluster 'monitoring-lab' (1 control-plane + 2 workers)...
Creating cluster "monitoring-lab" ...
 ✓ Ensuring node image (kindest/node:v1.35.0) 🖼 
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-monitoring-lab"
You can now use your cluster with:

kubectl cluster-info --context kind-monitoring-lab

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
[INFO] Waiting for nodes to be ready...
node/monitoring-lab-control-plane condition met
node/monitoring-lab-worker condition met
node/monitoring-lab-worker2 condition met

[INFO] =========================================
[INFO]  Cluster is ready!
[INFO] =========================================

[INFO] To tear down:
[INFO]   /home/daniel/documents/workspace/testing/k8s_sandbox/kind_tools/cluster_setup.sh --clean --only
[INFO] Adding Prometheus Helm repo...
"prometheus-community" already exists with the same configuration, skipping
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "flink-operator-repo" chart repository
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈

[INFO] Installing kube-prometheus-stack...
[INFO] Using values file: /home/daniel/documents/workspace/testing/k8s_sandbox/k8s_tools/prometheus-grafana/values.yaml
namespace/monitoring created
Release "kube-prometheus-stack" does not exist. Installing it now.
NAME: kube-prometheus-stack
LAST DEPLOYED: Sat Feb 28 12:48:42 2026
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=kube-prometheus-stack"

Get Grafana 'admin' user password by running:

  kubectl --namespace monitoring get secrets kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Access Grafana local instance:

  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=kube-prometheus-stack" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

[INFO] Installation complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[INFO] ✔ Monitoring Stack Ready
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[INFO]  Grafana:      http://grafana.127.0.0.1.nip.io  (admin / admin)
[INFO]  Prometheus:   http://prometheus.127.0.0.1.nip.io
[INFO]  Alertmanager: http://alertmanager.127.0.0.1.nip.io

[INFO]  Useful commands:
[INFO]   kubectl -n monitoring get pods
[INFO]   kubectl -n monitoring get servicemonitors
[INFO]   kubectl -n monitoring get prometheusrules

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Teardown
```bash
user@HOST:~/k8s_sandbox/cluster_setups/monitoring_lab$ ./teardown.sh 
```

### Output

```bash
Deleting kind cluster 'monitoring-lab'...
Deleting cluster "monitoring-lab" ...
Deleted nodes: ["monitoring-lab-worker2" "monitoring-lab-control-plane" "monitoring-lab-worker"]
Done.
```
