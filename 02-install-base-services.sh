#!/bin/sh

# ./registry.sh

#CLUSTER_NAME=my-local-cluster

#kind delete clusters $CLUSTER_NAME
#kind create cluster --name $CLUSTER_NAME --config kind-config.yaml


# install argocd

helm repo add argo https://argoproj.github.io/argo-helm
helm search repo argo/argo-cd
# prints something like:
# NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
# argo/argo-cd    9.3.7           v3.2.6          A Helm chart for Argo CD, a declarative, GitOps...
# helm show values argo/argo-cd --version 8.0.0 > argocd/values.yaml

helm upgrade --install argocd argo/argo-cd \
  --version 9.3.7 \
  --values argocd/values.yaml \
  --namespace argocd --create-namespace

# check APP VERSION from output of helm search repo argo/argo-cd matching the CHART VERSION
kubectl apply -k "https://github.com/argoproj/argo-cd/manifests/crds?ref=v3.2.6"

# username is admin
# print password to console
# kubectl get secret argocd-initial-admin-secret -n argocd \
#   -o jsonpath="{.data.password}" | base64 -d


# taken from here: https://stackoverflow.com/questions/68297354/what-is-the-default-password-of-argocd
kubectl -n argocd patch secret argocd-secret \
-p '{"stringData": {"admin.password": "'$(htpasswd -bnBC 10 "" admin | tr -d ':\n' | sed 's/$2y/$2a/')'", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'


# kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
# kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml


# install traefik

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f traefik/values.yaml


kubectl apply -f traefik/ingressroute.yaml 
kubectl apply -f argocd/ingressroute.yaml 

gomplate -f argocd/repo-secret.yaml.tpl
gomplate -f argocd/repo-secret.yaml.tpl | kubectl apply -f -
