#!/bin/bash
printf "\n..Canary Deployment for promote..\n"

image_tag=$1 # working version
namespace=$2

image=liammoat/canary-app

if [[ -z "$1" ]]
  then        
    read -p "New Image version/tag (e.g: v2): "    
    if [[ -z $REPLY ]]
    then
      printf "\n...Image tag is mandatory. exiting\n"
      exit 0
    fi
    image_tag=$REPLY
fi

if [[ -z "$2" ]]; 
  then        
    read -p "Target Namespace (default is canary-flagger) : "
    namespace=${REPLY:-"canary-flagger"}
fi

new_image=$image":"$image_tag
printf "\n...setting image to $new_image\n"
kubectl set image deployment/myapp myapp=$new_image -n $namespace

pritnf "\n...monitoring canaries...\n"
watch kubectl get canaries -n $namespace

printf "\n...complete\n"