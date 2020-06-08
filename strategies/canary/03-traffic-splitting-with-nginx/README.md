# Canary - Traffic Splitting with NGINX

The previous two demos have used a Kubernetes service to distribute traffic over two deployments. In this demonstration we will use a NGINX Ingress Controller to split the traffic. We will continue to use Helm.

## Steps

### Install NGINX Ingress Controller
If you don't have an NGINX Ingress Controller already, use the commands below to deploy one using Helm.

```bash
# add the official stable repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# use Helm to deploy an NGINX ingress controller
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress-nginx \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.metrics.enabled=true \
    --set controller.podAnnotations."prometheus\.io/scrape"=true \
    --set controller.podAnnotations."prometheus\.io/port"=10254
```

### Setup the environment

```bash
# create a namespace
kubectl create ns canary-nginx

# package helm chart
helm package ./canary-chart

# install helm chart
helm install my-release \
        ./canary-chart-0.1.0.tgz -n canary-nginx
```

### Create a canary deployment

```bash
# upgrade helm release
# - set canary imageTag and weight
helm upgrade my-release \
        --reuse-values \
        --set canary.imageTag=v2 \
        --set canary.weight=30 \
        ./canary-chart-0.1.0.tgz -n canary-nginx
```

#### Promote canary

```bash
# upgrade helm release
# - set stable imageTag
# - set canary imageTag and weight
helm upgrade my-release \
        --reuse-values \
        --set stable.imageTag=v2 \
        --set canary.imageTag=v2 \
        --set canary.weight=50 \
        ./canary-chart-0.1.0.tgz -n canary-nginx
```

#### Reject canary

```bash
# rollback helm release
helm rollback my-release -n canary-nginx
```

[[Next - Flagger with NGINX]](../04-flagger-with-nginx/)