#!/bin/bash
printf "\n..Promote Canary Image to Stable Deployment..\n"

instance_count=$1
image_tag=$2

namespace="canary-native"
image="lmregistryacr.azurecr.io/canary-app"

# accept parameters for number of instances 
if [[ -z "$1" ]] 
  then        
    read -p "Required Number of Instances in total (default is 10): "
    instance_count=${REPLY:-10}
fi

if [[ -z "$2" ]]
  then        
    read -p "New Image version/tag (e.g: v2): "    
    if [[ -z $REPLY ]]
    then
      printf "\n...Image tag is mandatory. exiting\n"
      exit 0
    fi
    image_tag=$REPLY
fi

new_image=$image":"$image_tag
printf "\n...setting image to $new_image on myapp deployment \n"
kubectl set image deployment/myapp myapp=$new_image -n $namespace

# update stable deployment to use canary image and scales replicas to 10
# Blue-green / canary hybrid approach?
printf "\n...scaling myapp deployment to $instance_count\n"
kubectl scale --replicas=$instance_count deployment/myapp -n $namespace

# set canary to 0 replicas
printf "\n...scaling myapp-canary deployment to 0\n"
kubectl scale --replicas=0 deployment/myapp-canary -n $namespace