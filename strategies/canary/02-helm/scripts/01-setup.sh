# ./scripts/01-setup.sh v1 10

NAMESPACE="canary-helm"
TAG=$1
REPLICAS=$2

# delete namespace if exists
kubectl delete ns $NAMESPACE

# create namespace
kubectl create ns $NAMESPACE

# package helm chart
helm package ./canary-chart

# deploy manifests
helm install my-release \
        --set stable.imageTag=$TAG \
        --set stable.replicas=$REPLICAS \
        --set canary.imageTag=$TAG \
        --set canary.replicas=0 \
        ./canary-chart-0.1.0.tgz -n $NAMESPACE

# get all resources
kubectl get all -n $NAMESPACE