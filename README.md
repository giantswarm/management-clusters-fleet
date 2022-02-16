# management-clusters-fleet

GitOps for Giant Swarm management clusters

## Layout

- `bootstrap` holds actual definitions applied to MCs, but it's content id automatically
  generates using `Makefile.custom.mk`
- `manifests` contains actual source config files
  - `customer` includes Flux bases used for customer's Flux (`flux-system` namespace)
  - `giantswarm` incudes Flux bases for our (GS) Flux (`flux-giantswarm` namespace)
  - `provider` includes per-provider (and if needed per-installation) configuration
    that uses bases from `customer` and `giantswarm` to generate MC configuration
    `Kustomization` CRs
    - `customer-[PROVIDER_TYPE]` - basic Kustomization that renders customer's Flux
      on installation of `[PROVIDER_TYPE]`
    - `gs-[PROVIDER_TYPE]` - basic Kustomization that renders our Flux deployment
      on installation of `[PROVIDER_TYPE]`

## Updating manifests

Remember that content of `bootstrap` is generated, so after you're done with changes in
`manifests` be sure to run:

```bash;
make; make
```

and commit resulting changes.

## Adding providers

To add a new provider, you need to create appropriate directories in `manifests/`.
They need to render both our and customer's Flux deployment. Remember to register them
at the top of [Makefile.custom.mk](Makefile.custom.mk).

## Change Flux version

To change the Flux version in rendered manifests, update `FLUX_VERSION` in
[Makefile.custom.mk](Makefile.custom.mk).
