# management-clusters-fleet

GitOps for Giant Swarm management clusters

## Layout

- AppProject: `argocd` contains:
  - Application: `projects` manages:
    - `argocd` AppProject
    - `collections` AppProject
  - Application: `argocd` manages:
    - Upstream Argo CD manifests stored in `build/argocd/`
- AppProject: `collections`:
  - Application: `provider-collection` manages:
    - Manifests from the provider-specific app collection

## Updating Argo CD manifests

Run

```
hack/update-argocd-manifests.sh <version>
```

This script will render:
  - `build/argocd/install.yaml` file with all the upstream resources
  - `build/provider/<provider>.yaml` file with the project for self-managed provider application.

If no version provided, script uses `master` branch and `latest` Docker image.
