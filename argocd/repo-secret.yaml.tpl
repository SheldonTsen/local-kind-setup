
apiVersion: v1
kind: Secret
metadata:
  name: private-github-repos
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repo-creds
stringData:
  url: {{ env.Getenv "GITHUB_REPO_URL" }}
  username: {{ env.Getenv "GITHUB_USER_NAME" }}
  password: {{ env.Getenv "GITHUB_TOKEN"}}
