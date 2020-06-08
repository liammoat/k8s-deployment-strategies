# Canary - Kubernetes Native

The purpose of this demo is to show the mechanics of using a Kubernetes service to perform a simple canary deployment. The demo changes the distribution of traffic between a stable and canary deployment by altering the number of replicas.

## Steps

### Setup the environment

```bash
# create a namespace
kubectl create ns canary-native

# create a stable deployment
kubectl apply -f ./manifests/deployment.yaml -n canary-native

# create a canary deployment
kubectl apply -f ./manifests/deployment-canary.yaml -n canary-native

# create a service
kubectl apply -f ./manifests/service.yaml -n canary-native

# create a fortio pod
kubectl apply -f ./manifests/fortio.yaml -n canary-native
```

### Create a canary deployment

```bash
# update the image of the canary deployment
kubectl set image deployment/myapp-canary myapp-canary=liammoat/canary-app:v2 -n canary-native

# scale the stable deployment
kubectl scale --replicas=7 deployment/myapp -n canary-native

# scale the canary deployment
kubectl scale --replicas=3 deployment/myapp-canary -n canary-native
```

#### Promote canary

```bash
# update the image of the stable deployment
kubectl set image deployment/myapp myapp=$new_image -n canary-native

# scale the stable deployment
kubectl scale --replicas=10 deployment/myapp -n canary-native

# scale the canary deployment
kubectl scale --replicas=0 deployment/myapp-canary -n canary-native
```

#### Reject canary

```bash
# scale the stable deployment
kubectl scale --replicas=10 deployment/myapp -n canary-native

# scale the canary deployment
kubectl scale --replicas=0 deployment/myapp-canary -n canary-native
```

[[Next]](../02-helm/)