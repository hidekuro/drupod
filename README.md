# drupod

Drupal development environment on Kubernetes + Helm + Skaffold.

# Requirements

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [Helm](https://github.com/helm/helm)
- [Skaffold](https://github.com/GoogleContainerTools/skaffold)

# Setup

1. Create minikube vm
2. Enable minikube addons
3. Initialize helm
4. Copy `.env.example` to `.env`
5. deploy using skaffold

```bash
# create minikube vm
minikube start --memory=4096

# enable addons
minikube addons enable ingress
minikube addons enable registry
minikube addons enable registry-creds

# initialize helm
helm init

# copy .env file
cp .env.example .env
```

# In local development phase

Use docker-compose to local development.

```bash
eval $(minikube docker-env)
docker-compose up --build -d
```

and access `http://$(minikube ip):10080/`

# Testing deploy to local cluster

Modify your `hosts` to resolve domain `drupod.minikube.internal` to IP shown by `minikube ip`.

After that, do `skaffold run` or `skaffold dev`.

```bash
eval $(minikube docker-env)

# watch mode
skaffold dev

# or one-shot (closer to CI/CD tools)
skaffold run
```

and access http://drupod.minikube.internal/

- Require edit dns resolver (`/etc/hosts` or DNS Entry) to `drupod.minikube.internal` resolve to your `minikube ip`.

# Every morning tasks

Prepare to use `skaffold`, `helm`, `docker`, `docker-compose`.

```bash
minikube start
eval $(minikube docker-env)
```

## NOTE

If your host is Windows, you need define env vars `COMPOSE_CONVERT_WINDOWS_PATHS=1` to avoid to docker-compose's volume mount problem.

# License

[CC0](https://creativecommons.org/publicdomain/zero/1.0/)
