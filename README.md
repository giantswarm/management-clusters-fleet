# management-clusters-fleet

GitOps for Giant Swarm management clusters

## Layout

- AppProject: `argocd` contains:
  - Application: `argocd` manages:
    -  upstream Argo CD manifests
    - `argocd` AppProject CR
    - `argocd` Application CR
    - `collections` AppProject CR
    - `provider-collection` Application CR
  - Application: `provider-collection` manages:
    - Manifests from the provider-specific app collection

## Updating Argo CD manifests

Run

```
make all
```

This make target will:
  - update `bases/upstream-argocd/install.yaml` with version of ArgoCD specified in Makefile.
  - render `bootstrap/<provider>.yaml` file with the project for self-managed provider application.
  - render `bootstrap/<provider>-test.yaml` file with `selfHeal` disabled for test installations.

Those directories' content can be rendered separately using different make targets:
  - `make build/argocd` - updates upstream ArgoCD.
  - `make build/provider` - updates `bootstrap/` resources.

To change the version of rendered manifests, update `ARGOCD_VERSION` in [Makefile.custom.mk](Makefile.custom.mk).
You might have to change image override in `manifests/argocd/kustomization.yaml` as well.
