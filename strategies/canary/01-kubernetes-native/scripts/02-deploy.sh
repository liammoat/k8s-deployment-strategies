#!/bin/bash
printf "\n..Canary Deployment..\n"

instance_count=$1
canary_percent=$2
image_tag=$3

namespace="canary-native"
image="lmregistryacr.azurecr.io/canary-app"

# accept parameters for number of instances and % of canary (10, 20% canary) and image tag for canary
if [[ -z "$1" ]] 
  then        
    read -p "Required Number of Instances in total (default is 10): "
    instance_count=${REPLY:-10}
fi

if [[ -z "$2" ]]
  then        
    read -p "Percentage of Canary Instances (default is 20 %): "
    canary_percent=${REPLY:-20}
fi

if [[ -z "$3" ]]
  then        
    read -p "Image Tag: (e.g: v2)"    
    if [[ -z $REPLY ]]
    then
      printf "\n...Image tag is mandatory. exiting\n"
      exit 0
    fi
    image_tag=$REPLY
fi

# updates canary deployment
printf "\n...applying canary deployment.yaml\n"
kubectl apply -f ../manifests/deployment-canary.yaml -n $namespace

new_image=$image":"$image_tag
printf "\n...setting image to $new_image\n"
kubectl set image deployment/myapp-canary myapp-canary=$new_image -n $namespace

# scale replicas for deployment and canary deployment
canary_instances=$(($instance_count * $canary_percent / 100))
remaining_instances=$(($instance_count - $canary_instances))

printf "\n...scaling myapp deployment to $remaining_instances\n"
kubectl scale --replicas=$remaining_instances deployment/myapp -n $namespace

printf "\n...scaling myapp-canary deployment to $canary_instances\n"
kubectl scale --replicas=$canary_instances deployment/myapp-canary -n $namespace

printf "\n...complete\n"