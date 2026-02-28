# Install Kind

Depends On:
- [[install_go]]
- [[install_docker]] or [[install_nerdctl]] or [[install_podman]]

```bash
# Install
go install sigs.k8s.io/kind@latest
# or just grab the binary
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/

# Create a cluster
kind create cluster --name test-deploy

# Use it
kubectl cluster-info --context kind-test-deploy

# Tear it down
kind delete cluster --name test-deploy
```

