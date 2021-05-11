# management-clusters-fleet
GitOps for Giant Swarm management clusters

## Updating Argo CD manifests

Running

```
hack/update-argocd-manifests.sh <version>
```

This script will render `manifests/install.yaml` file with all the required resources.
If no version provided, script uses `master` branch and `latest` Docker image.
