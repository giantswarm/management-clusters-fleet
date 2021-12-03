AUTOGENMSG := \# This is an auto-generated file. DO NOT EDIT

MANIFESTS := $(shell find manifests)

KUSTOMIZE := bin/kustomize

HELM := bin/helm

.PHONY: all
all: manifests/bases/flux-app bootstrap

.PHONY: manifests/bases/flux-app
manifests/bases/flux-app: FLUXAPP_VERSION := v0.7.1
manifests/bases/flux-app: FLUXAPP_REPOSITORY := https://github.com/giantswarm/flux-app.git
manifests/bases/flux-app:
	@echo "====> $@"
	rm -rf manifests/bases/flux-app/
	git -c advice.detachedHead=false clone --quiet --depth 1 --branch ${FLUXAPP_VERSION} ${FLUXAPP_REPOSITORY} manifests/bases/flux-app/
	sed -i "s/version: 0.0.0/version: $(FLUXAPP_VERSION)/g" manifests/bases/flux-app/helm/flux-app/Chart.yaml

BOOTSRAP_DEPS :=
BOOTSRAP_DEPS += bootstrap/aws-flux.yaml
bootstrap: $(BOOTSRAP_DEPS)

bootstrap/%.yaml: $(KUSTOMIZE) $(HELM) $(MANIFESTS)
	@echo "====> $@"
	mkdir -p bootstrap
	echo "$(AUTOGENMSG)" > $@
	ln manifests/bases/flux-app/helm/flux-app/values.yaml manifests/provider/$*/values.yaml
	$(KUSTOMIZE) build --enable-helm --helm-command="$(HELM)" manifests/provider/$* >> $@

$(KUSTOMIZE): ## Download kustomize locally if necessary.
	@echo "====> $@"
	$(call go-get-tool,$(KUSTOMIZE),sigs.k8s.io/kustomize/kustomize/v4@v4.4.1)

$(HELM): ## Download helm locally if necessary.
	@echo "====> $@"
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | HELM_INSTALL_DIR=bin USE_SUDO=false bash

# go-get-tool will 'go get' any package $2 and install it to $1.
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
define go-get-tool
set -e ;\
TMP_DIR=$$(mktemp -d) ;\
cd $$TMP_DIR ;\
go mod init tmp ;\
echo "Downloading $(2)" ;\
GOBIN=$(PROJECT_DIR)/bin go get $(2) ;\
rm -rf $$TMP_DIR
endef
