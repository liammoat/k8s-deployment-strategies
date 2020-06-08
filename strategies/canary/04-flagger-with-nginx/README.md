# Canary - Flagger with NGINX

[Flagger](https://flagger.app/) is a Kubernetes operator that automates the promotion of canary deployments within a Kubernetes environment. It supports a number of tools including Istio, Linkerd, App Mesh, Contour, Gloo, NGINX. In this demonstration we will be using Flagger with NGINX to perform progressive traffic shifting (canary deployment).

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

### Install Flagger
If you don't have Flagger already installed, use the commands below to deploy it using Helm.

```bash
# add the official flagger repo
helm repo add flagger https://flagger.app

# use Helm to install Flagger and the Prometheus add-on
helm upgrade -i flagger flagger/flagger \
    --namespace ingress-nginx \
    --set prometheus.install=true \
    --set meshProvider=nginx
```

### Setup the environment

```bash
# create a namespace
kubectl create ns canary-flagger

# create an initial deployment
kubectl apply -f ./manifests/deployment.yaml -n canary-flagger

# create a Horizontal Pod Autoscaler
kubectl apply -f ./manifests/hpa.yaml -n canary-flagger

# create an ingress resource"
kubectl apply -f ./manifests/ingress.yaml -n canary-flagger

# create a canary custom resource
kubectl apply -f ./manifests/canary.yaml -n canary-flagger

# create a fortio pod
kubectl apply -f ./manifests/fortio.yaml -n canary-flagger
```

### Create a canary deployment

```bash
# update the image of the deployment
kubectl set image deployment/myapp myapp=liammoat/canary-app:v2 -n canary-flagger
```

## Troubleshooting

### Check for incoming traffic
Since this demo doesn't use Service Mesh or Grafana, use one of the following options to check for incoming traffic:

1. Follow the logs on the Pod itself:

    ```bash
    kubectl logs pod/myapp-{podid} --follow -n canary-flagger             
    ```

2. Check Flagger's Prometheus dashboard:

    ```bash
    kubectl port-forward service/flagger-pormetheus 9090 -n ingress-nginx
    ```

3. Manually send traffic to Canary service:

```
kubectl port-forward service/myapp-canary 8080 -n canary-flagger
```

### Notes for performing a canary deployments

* With Fortio (or any load testing tool), make sure to send traffic via ingress-controller 
* You can send the traffic to private-ip of the ingress-controller if needed as well.
* If you don't do this, canary deployments as there will not be enough requests to validate the success metrics defined in `canary.yaml`.

* It's highly recommended to Grafana or something similar to monitor the success rate instead of relying on logs during deployments.

### Check recent events 

```bash
kubectl get ev -n canary-flagger -w
```