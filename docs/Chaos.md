# Chaos

The Chaos section of Axiom is ran on Rackspace's Spot managed Kubernetes offering. It is dirt cheap,
but nodes may become unavailable at any moment. For this reason it is only used for explicitly offloaded,
selected workloads.

## Liqo peering

Peering the 2 clusters is done through
[declarative peering](https://docs.liqo.io/en/stable/advanced/peering/peering-via-cr.html). In case of
disaster recovery the WireGuard secrets may have to be reconfigured.

Axiom is the consumer, Chaos is the provider. Axiom authenticates to Chaos under the user
"/CN=axiom/O=liqo-tenant". The certificate is going to expire February 12, 2027. A new certificate can be generated
using the shell script below. Make sure the Chaos kubectl context is selected.

```shell
openssl genrsa -out user.key 2048
openssl req -new -key user.key -out user.csr -subj "/CN=axiom/O=liqo-tenant"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: axiom
spec:
  request: $(cat user.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

kubectl certificate approve axiom
kubectl get csr axiom -o jsonpath='{.status.certificate}' | base64 -d > user.crt
```

## Liqo orchestration
