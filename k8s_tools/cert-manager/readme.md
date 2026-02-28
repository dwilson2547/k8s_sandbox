# Cert-Manager

### Description
Installs [cert-manager](https://cert-manager.io/) into the cluster using the official manifest. Waits for all three core deployments (`cert-manager`, `cert-manager-webhook`, and `cert-manager-cainjector`) to become ready before exiting.

### Dependencies:
- None

### Environment Variables
| Variable Name | Description | Default Value |
| ------------- | ----------- | ------------- |
| — | No configurable environment variables | — |

### Helm Values (If Applicable)
N/A

### Usage
Called from a cluster setup start script:
```bash
bash "${ROOT_DIR}/k8s_tools/cert-manager/install-cert-manager.sh"
```
