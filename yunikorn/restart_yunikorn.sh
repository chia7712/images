#!/bin/bash

# get path
BASEDIR=$(dirname $0)

# cleanup and rebuild
namespace="yunikorn"
kubectl delete deployment/yunikorn-scheduler -n $namespace \
; kubectl delete pods --all -n $namespace \
; kubectl delete clusterrolebinding yunikorn-rbac -n $namespace \
; kubectl delete serviceaccount yunikorn-admin -n $namespace \
; kubectl delete configmap yunikorn-configs -n $namespace \
; kubectl create namespace $namespace \
; kubectl create -f "$BASEDIR/yunikorn-rbac.yaml" \
&& kubectl create configmap yunikorn-configs --from-file=queues.yaml="$BASEDIR/queues.yaml" -n $namespace \
&& kubectl create -f "$BASEDIR/scheduler.yaml" -n $namespace

# prepare rbac for spark
kubectl delete rolebinding spark-on-yunikorn -n $namespace \
; kubectl create rolebinding spark-on-yunikorn --clusterrole=edit --serviceaccount=$namespace:default -n $namespace
