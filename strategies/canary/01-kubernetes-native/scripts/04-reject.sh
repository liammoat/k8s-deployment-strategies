#!/bin/bash
printf "\n..Reject Canary Deployment..\n"

instance_count=$1
stable_image_tag=$2
namespace=$3

image="liammoat/canary-app"


if [[ -z "$1" ]]
  then        
    read -p "Required Number of Instances in total (default is 10): "
    instance_count=${REPLY:-10}
fi

if [[ -z "$2" ]]
  then        
    read -p "Stable Image version/tag (e.g: v1): "    
    if [[ -z $REPLY ]]
    then
      printf "\n...Stable Image tag is mandatory. exiting\n"
      exit 0
    fi
    stable_image_tag=$REPLY
fi

if [[ -z "$3" ]]; 
  then        
    read -p "Target Namespace (default is canary-native) : "
    namespace=${REPLY:-"canary-native"}
fi

# set canary deployment to zero and stable to number of instances

stable_image=$image":"$stable_image_tag
printf "\n...Reverting image to $stable_image on myapp deployment \n"
kubectl set image deployment/myapp myapp=$stable_image -n $namespace

printf "\n...scaling myapp deployment to $instance_count\n"
kubectl scale --replicas=$instance_count deployment/myapp -n $namespace

# set canary to 0 replicas
printf "\n...scaling myapp-canary deployment to 0\n"
kubectl scale --replicas=0 deployment/myapp-canary -n $namespace