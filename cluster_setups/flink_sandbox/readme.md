# Flink Sandbox

### Tool Dependencies:
- [x] cert-manager
- [x] flink-operator

### Cluster Configuration
- Default - 3 node
- Name: flink-sandbox

### Env Overrides
- `CLUSTER_NAME`: flink-sandbox
- `FLINK_OPERATOR_VERSION`: 1.14.0
- `FLINK_OPERATOR_NAMESPACE`: flink-operator
- `FLINK_JOBS_NAMESPACE`: flink-jobs
- `FLINK_SERVICE_ACCOUNT`: flink

### Custom Additions
N/A

### Intended Use
- Testing the Flink Kubernetes Operator
  - Deploy and manage Flink jobs via CRDs
  - Example job manifest: `example_flink_job.yaml`

### Quick Start
```bash
bash start_flink_sandbox.sh

# Deploy the example job
kubectl apply -f example_flink_job.yaml -n flink-jobs

# Access Flink UI
kubectl port-forward svc/<job-name>-rest 8081:8081 -n flink-jobs
```

### Teardown
```bash
bash teardown.sh
```
