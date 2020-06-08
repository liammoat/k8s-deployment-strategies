# Canary - Kubernetes

The purpose of this demo is to show the mechanics of using a Kubernetes service to perform a simple canary deployment. The demo changes the distribution of traffic between a stable and canary deployment by altering the number of replicas.

## Steps

### Setup the environment

```bash
# create a namespace
kubectl create ns canary-k8s

# create a stable deployment
kubectl apply -f ./manifests/deployment.yaml -n canary-k8s

# create a canary deployment
kubectl apply -f ./manifests/deployment-canary.yaml -n canary-k8s

# create a service
kubectl apply -f ./manifests/service.yaml -n canary-k8s

# create a fortio pod
kubectl apply -f ./manifests/fortio.yaml -n canary-k8s
```

### Create a canary deployment

```bash
# update the image of the canary deployment
kubectl set image deployment/myapp-canary myapp-canary=liammoat/canary-app:v2 -n canary-k8s

# scale the stable deployment
kubectl scale --replicas=7 deployment/myapp -n canary-k8s

# scale the canary deployment
kubectl scale --replicas=3 deployment/myapp-canary -n canary-k8s
```

#### Promote canary

```bash
# update the image of the stable deployment
kubectl set image deployment/myapp myapp=v2 -n canary-k8s

# scale the stable deployment
kubectl scale --replicas=10 deployment/myapp -n canary-k8s

# scale the canary deployment
kubectl scale --replicas=0 deployment/myapp-canary -n canary-k8s
```

#### Reject canary

```bash
# scale the stable deployment
kubectl scale --replicas=10 deployment/myapp -n canary-k8s

# scale the canary deployment
kubectl scale --replicas=0 deployment/myapp-canary -n canary-k8s
```

[[Next]](../02-kubernetes-with-helm/)