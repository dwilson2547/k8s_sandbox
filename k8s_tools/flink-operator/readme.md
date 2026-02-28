# Flink Kubernetes Operator

### Description
Installs the [Apache Flink Kubernetes Operator](https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/) via Helm. Creates the operator namespace, the jobs namespace, and a dedicated Flink service account. Enables the admission webhook.

### Dependencies:
- [x] cert-manager

### Environment Variables
| Variable Name | Description | Default Value |
| ------------- | ----------- | ------------- |
| `FLINK_OPERATOR_VERSION` | Flink Kubernetes Operator version to install | `1.14.0` |
| `FLINK_OPERATOR_NAMESPACE` | Namespace where the operator is deployed | `flink-operator` |
| `FLINK_JOBS_NAMESPACE` | Namespace where Flink jobs are submitted | `flink-jobs` |
| `FLINK_SERVICE_ACCOUNT` | Service account created in the jobs namespace | `flink` |

### Helm Values (If Applicable)
N/A — configuration is passed via `--set` flags directly in the install script.

### Usage
Called from a cluster setup start script:
```bash
bash "${ROOT_DIR}/k8s_tools/flink-operator/install-flink-operator.sh"

# With variable overrides
FLINK_OPERATOR_VERSION=1.10.0 FLINK_JOBS_NAMESPACE=my-jobs \
  bash "${ROOT_DIR}/k8s_tools/flink-operator/install-flink-operator.sh"
```

After a Flink job is deployed, access its UI via:
```bash
kubectl port-forward svc/<job-name>-rest 8081:8081 -n ${FLINK_JOBS_NAMESPACE}
```
