# management-clusters-fleet
GitOps for Giant Swarm management clusters


## Updating Argo CD manifests

Run

```
hack/update-argocd-manifests.sh <version>
```

This script will render `manifests/install-<provider>.yaml` files with
  - upstream resources
  - Argo CD project and its configuration per provider

If no version provided, script uses `master` branch and `latest` Docker image.
