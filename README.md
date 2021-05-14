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
make all
```

This make target will render:
  - `build/argocd/install.yaml` file with all the upstream resources
  - `build/provider/<provider>.yaml` file with the project for self-managed provider application.

Those directores content can be rendered separately using different make targets:
  - `make build/argocd`
  - `make build/provider`

To change the version of rendenred manifests, update `ARGOCD_VERSION` in [Makefile.custom.mk](Makefile.custom.mk).
