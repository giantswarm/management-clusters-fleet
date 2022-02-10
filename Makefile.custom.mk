AUTOGENMSG := \# This is an auto-generated file. DO NOT EDIT

MANIFESTS := $(shell find manifests)

KUSTOMIZE := ./bin/kustomize

HELM := ./bin/helm

.PHONY: all
all: manifests/flux-app bootstrap

.PHONY: manifests/flux-app
manifests/flux-app: FLUXAPP_VERSION := v0.7.1
manifests/flux-app:
	@echo "====> $@"
	git clean -fxd manifests/provider/
	find manifests/provider/ -wholename '*/kustomization.yaml' | grep -v 'charts' | xargs -I{} sed -i "0,/version:/{s/version: .*/version: $(FLUXAPP_VERSION)/g}" {}

BOOTSRAP_DEPS :=
BOOTSRAP_DEPS += bootstrap/gs-aws/gs-aws.yaml
BOOTSRAP_DEPS += bootstrap/gs-aws-china/gs-aws-china.yaml
BOOTSRAP_DEPS += bootstrap/customer-aws/customer-aws.yaml
BOOTSRAP_DEPS += bootstrap/gs-azure/gs-azure.yaml
BOOTSRAP_DEPS += bootstrap/customer-azure/customer-azure.yaml
BOOTSRAP_DEPS += bootstrap/gs-kvm/gs-kvm.yaml
BOOTSRAP_DEPS += bootstrap/customer-kvm/customer-kvm.yaml
BOOTSRAP_DEPS += bootstrap/gs-openstack-galaxy/gs-openstack-galaxy.yaml
BOOTSRAP_DEPS += bootstrap/gs-openstack-gamma/gs-openstack-gamma.yaml
BOOTSRAP_DEPS += bootstrap/gs-openstack-gravity/gs-openstack-gravity.yaml
bootstrap: $(BOOTSRAP_DEPS)

bootstrap/%.yaml: $(KUSTOMIZE) $(HELM) $(MANIFESTS)
	@echo "====> $@"
	mkdir -p $(@D)
	echo "$(AUTOGENMSG)" > $@
	$(KUSTOMIZE) build --load-restrictor LoadRestrictionsNone --enable-helm --helm-command="$(HELM)" manifests/provider/$(lastword $(subst /, ,$(@D))) >> $@

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
