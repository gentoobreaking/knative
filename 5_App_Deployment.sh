#!/bin/bash

cat << EOF > ./service.yaml
apiVersion: serving.knative.dev/v1alpha1 # Current version of Knative
kind: Service
metadata:
  name: helloworld-go # The name of the app
  namespace: default # The namespace the app will use
spec:
  template:
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go # The URL to the image of the app
          env:
            - name: TARGET # The environment variable printed out by the sample app
              value: "Go Sample v1"
EOF

kubectl apply --filename service.yaml

export INGRESSGATEWAY=knative-ingressgateway
if kubectl get configmap config-istio -n knative-serving &> /dev/null; then
   INGRESSGATEWAY=istio-ingressgateway
fi

kubectl get svc $INGRESSGATEWAY --namespace istio-system

# common use.
export IP_ADDRESS=$(kubectl get svc $INGRESSGATEWAY --namespace istio-system --output 'jsonpath={.status.loadBalancer.ingress[0].ip}')
# for minikube use.
#export IP_ADDRESS=$(kubectl get node  --output 'jsonpath={.items[0].status.addresses[0].address}'):$(kubectl get svc $INGRESSGATEWAY --namespace istio-system   --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo " - o find the host URL for your service."
kubectl get route helloworld-go  --output=custom-columns=NAME:.metadata.name,URL:.status.url

echo " - Verify"
curl -H "Host: helloworld-go.default.example.com" http://${IP_ADDRESS}

# --- END --- #
