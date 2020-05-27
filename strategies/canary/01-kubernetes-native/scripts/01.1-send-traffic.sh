#!/bin/bash
printf "\n..Send traffic..\n"

namespace=$1

if [[ -z "$1" ]]; 
  then        
    read -p "Target Namespace (default is canary-native) : "
    namespace=${REPLY:-"canary-native"}
fi

printf "\n...sending traffic\n"
FORTIO_POD=$(kubectl get pod -n $namespace | grep fortio | awk '{ print $1 }')
printf "\n..$FORTIO_POD\n"
kubectl exec -n $namespace -it $FORTIO_POD -c fortio -- fortio load -allow-initial-errors -t 0 http://myapp:8080/
