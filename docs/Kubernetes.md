# Kubernetes

## Unfortunately manually applied CRDs

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
```

## Manually created cluster secrets

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: cloudflare-api-token-secret
    namespace: cert-manager
type: Opaque
stringData:
    api-token: <API Token>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-authentik-secrets
    namespace: authentik
type: Opaque
stringData:
    secret-key: <openssl rand -base64 32>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-telegrambot-alertmanager
    namespace: observability
type: Opaque
stringData:
    token: <Telegram BotFather HTTP token>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-bitwarden-installation-credentials
    namespace: vaultwarden
type: Opaque
stringData:
    id: <Bitwarden selfhosting installation ID>
    key: <Bitwarden selfhosting installation key>
```

```yaml
apiVersion: v1
data:
    cloud: <see below>
kind: Secret
metadata:
    creationTimestamp: null
    labels:
        component: velero
    name: cloud-credentials
    namespace: velero
```

(contents of cloud key)

```toml
[default]
aws_access_key_id=...
aws_secret_access_key=...
```
