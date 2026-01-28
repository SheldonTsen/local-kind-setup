#!/bin/sh
set -e

kubectl apply -f example-app/app.yaml

kubectl create namespace argo-workflows --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f argoworkflows/app.yaml

# based off ingress configuration
echo "Logging into Argo CD..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=120s

yes | argocd login argocd.localhost:8080 --insecure --username admin --password admin --plaintext

APP_NAME="argo-workflows"
NAMESPACE="argocd"
TIMEOUT=300   # seconds
INTERVAL=10   # seconds
ELAPSED=0

echo "Waiting for Argo CD application '$APP_NAME' in namespace '$NAMESPACE' to be Synced and Healthy..."
while true; do
    STATUS=$(argocd app get "$APP_NAME" --output json 2>/dev/null | jq -r '.status.sync.status,.status.health.status' | paste -sd "," -)
    if [ "$STATUS" = "Synced,Healthy" ]; then
        echo "Application '$APP_NAME' is Synced and Healthy."
        break
    fi
    if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
        echo "Timeout waiting for application '$APP_NAME' to be ready."
        exit 1
    fi
    sleep "$INTERVAL"
    ELAPSED=$((ELAPSED + INTERVAL))
done

kubectl apply -f argoworkflows/example-wf.yaml

WF=$(kubectl create -n argo-workflows -f - -o name <<'EOF'
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: hello-world-
spec:
  workflowTemplateRef:
    name: hello-world-template
EOF
)

kubectl wait -n argo-workflows --for=condition=Completed "$WF" --timeout=120s && \
kubectl get -n argo-workflows "$WF" -o jsonpath='{.status.phase}{"\n"}'

