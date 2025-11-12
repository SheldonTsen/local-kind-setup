# Hello World Kind Setup

## To Start (Mac Only)

### Step 1
First time running? Run the following:
```
make install-tools
```

### Step 2 - Only if you want to use ArgoCD
Copy the `sample.env` file, rename it to `.env` file and populate it. You will need to create
an access token with read access to the correct repository.

### Step 3
Run:
```
make all
```

### Step 4 - ???


### Step 5 - Profit

URLs:
```
Traefik - http://localhost:9000/dashboard/#/ 
ArgoCD - argocd.localhost:8080, username: admin, password: admin
Demo App - http://guestbook.localhost:8080/
Argo Workflow - http://argo-workflows.localhost:8080/
```
