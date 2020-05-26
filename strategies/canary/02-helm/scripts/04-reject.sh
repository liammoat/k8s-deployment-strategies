# ./scripts/04-reject.sh canary-demo-02

NAMESPACE="canary-helm"

# rollback canary deployment
helm rollback my-release -n $NAMESPACE

# get all resources
kubectl get all -n $NAMESPACE     