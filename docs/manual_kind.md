# Kind User Manual

Depends On:
- [[install_kind]]
- [[install_kubectl]]

>[!note] WSL2 special notes
>https://kind.sigs.k8s.io/docs/user/using-wsl2/

>[!note] Official Quickstart
>https://kind.sigs.k8s.io/docs/user/quick-start/

Create cluster
```bash
kind create cluster # Default cluster context name is `kind`.
# Flags:
#   --name clustername
#   --config file.yaml

# List clusters
kind get clusters

# Cluster info 
kubectl cluster-info --context kind-kind

# Deleting a cluster
kind delete cluster # Defaults to `kind` if name is not specified


