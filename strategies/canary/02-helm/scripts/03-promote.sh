# ./scripts/03-promote.sh v2 10

NAMESPACE="canary-helm"
STABLE_TAG=$1
TOTAL_REPLICAS=$2

# upgrade release
# > set stable imageTag and replicas
# > reset canary replicas
helm upgrade my-release \
        --reuse-values \
        --set stable.imageTag=$STABLE_TAG \
        --set stable.replicas=$TOTAL_REPLICAS \
        --set canary.replicas=0 \
        ./canary-chart-0.1.0.tgz -n $NAMESPACE

# get all resources
kubectl get all -n $NAMESPACE