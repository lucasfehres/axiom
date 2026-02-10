# Kubernetes

## Unfortunately manually applied CRDs

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
```

## Registry credentials

```sh
kubectl create secret docker-registry regcred -n atlassian --docker-server=registry.axiom.lucasfehres.nl --docker-username='robot$rke2-axiom' --docker-password=PASSWORD
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
    name: axiom-cloudflare-api-key
    namespace: kube-system
type: Opaque
stringData:
    apiKey: <API Token>
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
kind: Secret
metadata:
    name: cloud-credentials
    namespace: velero
data:
    cloud: <see below>
```

(contents of cloud key)

```toml
[default]
aws_access_key_id=...
aws_secret_access_key=...
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-s3-creds
    namespace: authentik
stringData:
    ACCESS_KEY_ID: <S3 access key ID>
    ACCESS_SECRET_KEY: <S3 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-s3-creds
    namespace: vaultwarden
stringData:
    ACCESS_KEY_ID: <S3 access key ID>
    ACCESS_SECRET_KEY: <S3 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-s3-creds
    namespace: atlassian
stringData:
    ACCESS_KEY_ID: <S3 access key ID>
    ACCESS_SECRET_KEY: <S3 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-s3-creds
    namespace: harbor
stringData:
    ACCESS_KEY_ID: <S3 access key ID>
    ACCESS_SECRET_KEY: <S3 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-s3-creds
    namespace: ejbca
stringData:
    ACCESS_KEY_ID: <S3 access key ID>
    ACCESS_SECRET_KEY: <S3 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-b2-creds
    namespace: authentik
stringData:
    ACCESS_KEY_ID: <B2 access key ID>
    ACCESS_SECRET_KEY: <B2 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-b2-creds
    namespace: vaultwarden
stringData:
    ACCESS_KEY_ID: <B2 access key ID>
    ACCESS_SECRET_KEY: <B2 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-b2-creds
    namespace: atlassian
stringData:
    ACCESS_KEY_ID: <B2 access key ID>
    ACCESS_SECRET_KEY: <B2 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-b2-creds
    namespace: harbor
stringData:
    ACCESS_KEY_ID: <B2 access key ID>
    ACCESS_SECRET_KEY: <B2 secret access key>
```

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: axiom-cnpg-b2-creds
    namespace: ejbca
stringData:
    ACCESS_KEY_ID: <B2 access key ID>
    ACCESS_SECRET_KEY: <B2 secret access key>
```
