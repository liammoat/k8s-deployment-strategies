#!/bin/bash

instance_count=$1
namespace="canary-native"

# accept parameter for number of instances (default 10)
if [[ -z "$1" ]]; # or [ $# -eq 0 ]
  then        
    read -p "Required Number of Instances (default is 10): "
    instance_count=$REPLY
fi

# delete namespace if exists
echo "...deleting $namespace namespace if it already exists.."
kubectl delete ns $namespace

# create namesapce
echo "...creating $namespace namespace.."
kubectl create ns $namespace

# deploy manifests
echo "...creating deployment for deployment.yaml"
kubectl apply -f ../manifests/deployment.yaml -n $namespace

if [[ -z "$instance_count" ]]
then
  echo "...setting replicas to default instance count of 10"
else
  echo "...scaling deployment to $instance_count"
  kubectl scale --replicas=$instance_count deployment/myapp -n $namespace
fi

echo "...creating a service"
kubectl apply -f ../manifests/service.yaml -n $namespace

echo "...creating a service monitor"
kubectl apply -f ../manifests/servicemonitor.yaml

echo "...done"