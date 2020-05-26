# ./scripts/02-deploy.sh v2 10 3

NAMESPACE="canary-helm"
CANARY_TAG=$1
TOTAL_REPLICAS=$2
CANARY_REPLICAS=$3

STABLE_REPLICAS="$(($TOTAL_REPLICAS-$CANARY_REPLICAS))"

# upgrade release
# > set stable replicas
# > set canary imageTag and replicas
helm upgrade my-release \
        --reuse-values \
        --set stable.replicas=$STABLE_REPLICAS \
        --set canary.imageTag=$CANARY_TAG \
        --set canary.replicas=$CANARY_REPLICAS \
        ./canary-chart-0.1.0.tgz -n $NAMESPACE

# get all resources
kubectl get all -n $NAMESPACE     