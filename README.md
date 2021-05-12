# management-clusters-fleet
GitOps for Giant Swarm management clusters


## Updating Argo CD manifests

Run

```
hack/update-argocd-manifests.sh <version>
```

This script will render:
  - `build/argocd/install.yaml` file with all the upstream resources
  - `build/mc-fleet/<provider>.yaml` file with the project for self-managed provider application.

If no version provided, script uses `master` branch and `latest` Docker image.
