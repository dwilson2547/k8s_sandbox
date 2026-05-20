# Flink operator cluster example run

## Start Cluster
```bash
user@HOST:~/k8s_sandbox/cluster_setups/flink_sandbox$ ./start_flink_sandbox.sh
```

### Output
```bash
[INFO] Creating Kind cluster 'flink-sandbox' (1 control-plane + 2 workers)...
Creating cluster "flink-sandbox" ...
 ✓ Ensuring node image (kindest/node:v1.35.0) 🖼 
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-flink-sandbox"
You can now use your cluster with:

kubectl cluster-info --context kind-flink-sandbox

Have a nice day! 👋
[INFO] Waiting for nodes to be ready...
node/flink-sandbox-control-plane condition met
node/flink-sandbox-worker condition met
node/flink-sandbox-worker2 condition met

[INFO] =========================================
[INFO]  Cluster is ready!
[INFO] =========================================

[INFO] To tear down:
[INFO]   /home/daniel/documents/workspace/testing/k8s_sandbox/kind_tools/cluster_setup.sh --clean --only
[INFO] Installing cert-manager...
namespace/cert-manager created
customresourcedefinition.apiextensions.k8s.io/challenges.acme.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/orders.acme.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/certificaterequests.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/certificates.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/clusterissuers.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/issuers.cert-manager.io created
serviceaccount/cert-manager-cainjector created
serviceaccount/cert-manager created
serviceaccount/cert-manager-webhook created
clusterrole.rbac.authorization.k8s.io/cert-manager-cainjector created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-issuers created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-clusterissuers created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-certificates created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-orders created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-challenges created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-ingress-shim created
clusterrole.rbac.authorization.k8s.io/cert-manager-cluster-view created
clusterrole.rbac.authorization.k8s.io/cert-manager-view created
clusterrole.rbac.authorization.k8s.io/cert-manager-edit created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-approve:cert-manager-io created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-certificatesigningrequests created
clusterrole.rbac.authorization.k8s.io/cert-manager-webhook:subjectaccessreviews created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-cainjector created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-issuers created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-clusterissuers created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-certificates created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-orders created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-challenges created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-ingress-shim created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-approve:cert-manager-io created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-certificatesigningrequests created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-webhook:subjectaccessreviews created
role.rbac.authorization.k8s.io/cert-manager-cainjector:leaderelection created
role.rbac.authorization.k8s.io/cert-manager:leaderelection created
role.rbac.authorization.k8s.io/cert-manager-tokenrequest created
role.rbac.authorization.k8s.io/cert-manager-webhook:dynamic-serving created
rolebinding.rbac.authorization.k8s.io/cert-manager-cainjector:leaderelection created
rolebinding.rbac.authorization.k8s.io/cert-manager:leaderelection created
rolebinding.rbac.authorization.k8s.io/cert-manager-tokenrequest created
rolebinding.rbac.authorization.k8s.io/cert-manager-webhook:dynamic-serving created
service/cert-manager-cainjector created
service/cert-manager created
service/cert-manager-webhook created
deployment.apps/cert-manager-cainjector created
deployment.apps/cert-manager created
deployment.apps/cert-manager-webhook created
mutatingwebhookconfiguration.admissionregistration.k8s.io/cert-manager-webhook created
validatingwebhookconfiguration.admissionregistration.k8s.io/cert-manager-webhook created
[INFO] Waiting for cert-manager to be ready...
Waiting for deployment "cert-manager" rollout to finish: 0 of 1 updated replicas are available...
deployment "cert-manager" successfully rolled out
Waiting for deployment "cert-manager-webhook" rollout to finish: 0 of 1 updated replicas are available...
deployment "cert-manager-webhook" successfully rolled out
deployment "cert-manager-cainjector" successfully rolled out

[INFO] =========================================
[INFO]  Cert-manager is ready!
[INFO] =========================================

[INFO] Adding Flink Helm repo...
"flink-operator-repo" already exists with the same configuration, skipping
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "flink-operator-repo" chart repository
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈
[INFO] Installing Flink Kubernetes Operator v1.14.0...
namespace/flink-operator created
namespace/flink-jobs created
[INFO] Ensuring service account 'flink' exists in namespace 'flink-jobs'...
serviceaccount/flink created
I0228 12:23:19.614012 2759886 warnings.go:107] "Warning: spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`."
NAME: flink-kubernetes-operator
LAST DEPLOYED: Sat Feb 28 12:23:19 2026
NAMESPACE: flink-operator
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
[INFO] Waiting for Flink operator to be ready...
deployment "flink-kubernetes-operator" successfully rolled out

[INFO] =========================================
[INFO]  Flink operator is ready!
[INFO] =========================================

NAME                                         READY   STATUS    RESTARTS   AGE
flink-kubernetes-operator-856c59b955-5msqn   2/2     Running   0          22s

[INFO] Namespaces:
[INFO]   Operator: flink-operator
[INFO]   Jobs:     flink-jobs
[INFO] 
[INFO] To deploy a Flink job:
[INFO]   kubectl apply -f my-flink-job.yaml -n flink-jobs
[INFO] 
[INFO] To access Flink UI (after deploying a job):
[INFO]   kubectl port-forward svc/<job-name>-rest 8081:8081 -n flink-jobs
[INFO] 
```

## Teardown
```bash
user@HOST:~/k8s_sandbox/cluster_setups/flink_sandbox$ ./teardown.sh 
```

### Output

```bash
Deleting cluster "flink-sandbox" ...
Deleted nodes: ["flink-sandbox-control-plane" "flink-sandbox-worker2" "flink-sandbox-worker"]
```
