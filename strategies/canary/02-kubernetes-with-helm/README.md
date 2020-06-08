# Canary - Kubernetes with Helm

This demonstration takes the Kubernetes manifest files from the previous [demo](../01-kubernetes/) and packages them into a Helm chart.

## Steps

### Setup the environment

```bash
# create a namespace
kubectl create ns canary-helm

# package helm chart
helm package ./canary-chart

# install helm chart
helm install my-release \
        ./canary-chart-0.1.0.tgz -n canary-helm
```

### Create a canary deployment

```bash
# upgrade helm release
# - set stable replicas
# - set canary imageTag and replicas
helm upgrade my-release \
        --reuse-values \
        --set stable.replicas=7 \
        --set canary.imageTag=v2 \
        --set canary.replicas=3 \
        ./canary-chart-0.1.0.tgz -n canary-helm
```

#### Promote canary

```bash
# upgrade helm release
# - set stable imageTag and replicas
# - reset canary replicas
helm upgrade my-release \
        --reuse-values \
        --set stable.imageTag=v2 \
        --set stable.replicas=10 \
        --set canary.replicas=0 \
        ./canary-chart-0.1.0.tgz -n canary-helm
```

#### Reject canary

```bash
# rollback helm release
helm rollback my-release -n canary-helm
```

[[Next - Traffic Splitting with NGINX]](../03-traffic-splitting-with-nginx/)