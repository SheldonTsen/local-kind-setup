#!/bin/sh
set -e

# need to make more generic for CI/linux
brew install kind  # https://kind.sigs.k8s.io/docs/user/quick-start#installation
brew install helm  # https://helm.sh/docs/intro/install/
brew install kubectl  # https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos
brew install derailed/k9s/k9s  # https://github.com/IvanGDR/Installing-K9S-in-macOS-and-connecting-to-Remote-K8S-cluster?tab=readme-ov-file
brew install gomplate  # https://docs.gomplate.ca/installing/
brew install argocd  # https://argo-cd.readthedocs.io/en/stable/cli_installation/

# don't forget to update the colour scheme! 
# https://k9scli.io/topics/skins/

