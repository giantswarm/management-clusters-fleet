# management-clusters-fleet
GitOps for Giant Swarm management clusters

## Updating provider manifests

Run

```
hack/update-provider-manifests.sh
```

This script will render `build/<provider>-mc-fleet.yaml` file for every provider under
`manifests/provider` folder.


## Updating Argo CD manifests

Run

```
hack/update-argocd-manifests.sh <version>
```

This script will render `manifests/install.yaml` file with all the required resources.
If no version provided, script uses `master` branch and `latest` Docker image.
