#!/bin/bash

echo " - Needed to run twice. Was using a fresh Kind cluster."

kubectl apply --wait=true --selector knative.dev/crd-install=true \
 --filename https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
 --filename https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
 --filename https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml

kubectl apply --wait=true --selector knative.dev/crd-install=true \
 --filename https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
 --filename https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
 --filename https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml

kubectl apply \
   --filename https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
   --filename https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml

echo " - knative-serving"
kubectl get pods --namespace knative-serving
echo " - knative-eventing"
kubectl get pods --namespace knative-eventing
echo " - knative-monitoring"
kubectl get pods --namespace knative-monitoring

# --- END --- #
