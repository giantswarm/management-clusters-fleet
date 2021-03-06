AUTOGENMSG := \# This is an auto-generated file. DO NOT EDIT

MANIFESTS := $(shell find manifests)

KUSTOMIZE := ./bin/kustomize
KUSTOMIZE_VERSION ?= v4.5.4
KUSTOMIZE_INSTALL_SCRIPT ?= "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"

HELM := ./bin/helm

GNUSED := $(shell sed --version 1>/dev/null 2>&1; echo $$?)

.PHONY: all
all: manifests/flux-app bootstrap

.PHONY: manifests/flux-app
manifests/flux-app: FLUXAPP_VERSION := v0.11.0
manifests/flux-app:
	@echo "====> $@"
	git clean -fxd manifests/provider/
ifeq ($(GNUSED),0)
	find manifests/provider/ -wholename '*/kustomization.yaml' | grep -v 'charts' | xargs -I{} sed -i "0,/version:/{s/version: .*/version: $(FLUXAPP_VERSION)/g}" {}
else
	find manifests/provider/ -wholename '*/kustomization.yaml' | grep -v 'charts' | xargs -I{} sed -i "" "1,/version:/ s/version: .*/version: $(FLUXAPP_VERSION)/g" {}
endif

BOOTSTRAP_DEPS :=
BOOTSTRAP_DEPS += bootstrap/customer-aws/customer-aws.yaml
BOOTSTRAP_DEPS += bootstrap/customer-aws-china/customer-aws-china.yaml
BOOTSTRAP_DEPS += bootstrap/customer-azure/customer-azure.yaml
BOOTSTRAP_DEPS += bootstrap/customer-gcp/customer-gcp.yaml
BOOTSTRAP_DEPS += bootstrap/customer-kvm/customer-kvm.yaml
BOOTSTRAP_DEPS += bootstrap/customer-openstack/customer-openstack.yaml
BOOTSTRAP_DEPS += bootstrap/customer-vsphere/customer-vsphere.yaml
BOOTSTRAP_DEPS += bootstrap/customer-cloud-director/customer-cloud-director.yaml
BOOTSTRAP_DEPS += bootstrap/gs-aws/gs-aws.yaml
BOOTSTRAP_DEPS += bootstrap/gs-aws-china/gs-aws-china.yaml
BOOTSTRAP_DEPS += bootstrap/gs-azure/gs-azure.yaml
BOOTSTRAP_DEPS += bootstrap/gs-gcp/gs-gcp.yaml
BOOTSTRAP_DEPS += bootstrap/gs-kvm/gs-kvm.yaml
BOOTSTRAP_DEPS += bootstrap/gs-openstack/gs-openstack.yaml
BOOTSTRAP_DEPS += bootstrap/gs-openstack-vaultless/gs-openstack.yaml
BOOTSTRAP_DEPS += bootstrap/gs-rest-api/gs-rest-api.yaml
BOOTSTRAP_DEPS += bootstrap/gs-testing/gs-testing.yaml
BOOTSTRAP_DEPS += bootstrap/gs-vsphere/gs-vsphere.yaml
BOOTSTRAP_DEPS += bootstrap/gs-cloud-director/gs-cloud-director.yaml
bootstrap: $(BOOTSTRAP_DEPS)

bootstrap/%.yaml: $(KUSTOMIZE) $(HELM) $(MANIFESTS)
	@echo "====> $@"
	mkdir -p $(@D)
	echo "$(AUTOGENMSG)" > $@
	$(KUSTOMIZE) build --load-restrictor LoadRestrictionsNone --enable-helm --helm-command="$(HELM)" manifests/provider/$(lastword $(subst /, ,$(@D))) >> $@

## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

.PHONY: kustomize
$(KUSTOMIZE): $(LOCALBIN) ## Download kustomize locally if necessary.
	curl -s $(KUSTOMIZE_INSTALL_SCRIPT) | bash -s -- $(subst v,,$(KUSTOMIZE_VERSION)) $(LOCALBIN)

$(HELM): $(LOCALBIN) ## Download helm locally if necessary.
	@echo "====> $@"
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | HELM_INSTALL_DIR=$(LOCALBIN) USE_SUDO=false bash

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
