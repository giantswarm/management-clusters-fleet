AUTOGENMSG := \# This is an auto-generated file. DO NOT EDIT

MANIFESTS := $(shell find manifests)

KUSTOMIZE := bin/kustomize

HELM := bin/helm

.PHONY: all
all: manifests/bases/flux-app bootstrap

.PHONY: manifests/bases/flux-app
manifests/bases/flux-app: FLUXAPP_VERSION := v0.7.1
manifests/bases/flux-app: FLUXAPP_REPOSITORY := https://github.com/giantswarm/flux-app.git
manifests/bases/flux-app: WORK_DIR := $(shell mktemp -d -t ci-XXXXXXXXXX)
manifests/bases/flux-app: $(HELM)
	@echo "====> $@"
	git -c advice.detachedHead=false clone --quiet --depth 1 --branch ${FLUXAPP_VERSION} ${FLUXAPP_REPOSITORY} ${WORK_DIR}
	mkdir -p manifests/bases/flux-app
	echo "$(AUTOGENMSG)" > manifests/bases/flux-app/install.yaml
	sed -i "s/version: 0.0.0/version: $(FLUXAPP_VERSION)/g" ${WORK_DIR}/helm/flux-app/Chart.yaml
	$(HELM) template "flux-app-$(FLUXAPP_VERSION)" ${WORK_DIR}/helm/flux-app >> manifests/bases/flux-app/install.yaml
	rm -rf $(WORK_DIR)

BOOTSRAP_DEPS :=
BOOTSRAP_DEPS += bootstrap/aws-flux.yaml
bootstrap: $(BOOTSRAP_DEPS)

bootstrap/%.yaml: $(KUSTOMIZE) $(MANIFESTS)
	@echo "====> $@"
	mkdir -p bootstrap
	echo "$(AUTOGENMSG)" > $@
	$(KUSTOMIZE) build manifests/provider/$* >> $@

$(KUSTOMIZE): ## Download kustomize locally if necessary.
	@echo "====> $@"
	$(call go-get-tool,$(KUSTOMIZE),sigs.k8s.io/kustomize/kustomize/v4@v4.4.1)

$(HELM): ## Download helm locally if necessary.
	@echo "====> $@"
	$(call go-get-tool,$(HELM),helm.sh/helm/v3@v3.7.1)

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
