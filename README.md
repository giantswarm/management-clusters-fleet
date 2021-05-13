# management-clusters-fleet

GitOps for Giant Swarm management clusters

## Project/Application structure

- AppProject: `management-clusters-fleet` contains:
    - Application: `management-clusters-fleet` manages:
        - `management-clusters-fleet` AppProject
        - `management-clusters-fleet-collections` AppProject
    - Application: `management-clusters-fleet-argocd` manages:
        - Upstream Argo CD manifests stored in `build/argocd/`
- AppProject: `management-clusters-fleet-collections`:
    - TBD

## Updating Argo CD manifests

Run

```
hack/update-argocd-manifests.sh <version>
```

This script will render:
  - `build/argocd/install.yaml` file with all the upstream resources
  - `build/provider/<provider>.yaml` file with the project for self-managed provider application.

If no version provided, script uses `master` branch and `latest` Docker image.
