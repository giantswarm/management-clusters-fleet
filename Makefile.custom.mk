AUTOGENMSG := \# This is an auto-generated file. DO NOT EDIT

MANIFESTS := $(shell find manifests)

KUSTOMIZE := bin/kustomize

.PHONY: all
all: manifests/bases/upstream-argocd bootstrap

.PHONY: manifests/bases/upstream-argocd
manifests/bases/upstream-argocd: ARGOCD_VERSION := v2.1.0
manifests/bases/upstream-argocd: ARGOCD_REPOSITORY := https://github.com/argoproj/argo-cd.git
manifests/bases/upstream-argocd: WORK_DIR := $(shell mktemp -d -t ci-XXXXXXXXXX)
manifests/bases/upstream-argocd: $(KUSTOMIZE)
	@echo "====> $@"
	git -c advice.detachedHead=false clone --quiet --depth 1 --branch ${ARGOCD_VERSION} ${ARGOCD_REPOSITORY} ${WORK_DIR}
	mkdir -p manifests/bases/upstream-argocd
	echo "$(AUTOGENMSG)" > manifests/bases/upstream-argocd/install.yaml
	$(KUSTOMIZE) build "$(WORK_DIR)/manifests/cluster-install" >> manifests/bases/upstream-argocd/install.yaml
	rm -rf $(WORK_DIR)

BOOTSRAP_DEPS :=
BOOTSRAP_DEPS += bootstrap/aws.yaml
BOOTSRAP_DEPS += bootstrap/aws-test.yaml
BOOTSRAP_DEPS += bootstrap/aws-china.yaml
BOOTSRAP_DEPS += bootstrap/aws-china-test.yaml
BOOTSRAP_DEPS += bootstrap/azure.yaml
BOOTSRAP_DEPS += bootstrap/azure-test.yaml
BOOTSRAP_DEPS += bootstrap/kvm.yaml
BOOTSRAP_DEPS += bootstrap/kvm-test.yaml
BOOTSRAP_DEPS += bootstrap/vmware.yaml
BOOTSRAP_DEPS += bootstrap/vmware-test.yaml
bootstrap: $(BOOTSRAP_DEPS)

bootstrap/%.yaml: $(KUSTOMIZE) $(MANIFESTS)
	@echo "====> $@"
	mkdir -p bootstrap
	echo "$(AUTOGENMSG)" > $@
	$(KUSTOMIZE) build manifests/provider/$* >> $@

$(KUSTOMIZE): ## Download kustomize locally if necessary.
	@echo "====> $@"
	$(call go-get-tool,$(KUSTOMIZE),sigs.k8s.io/kustomize/kustomize/v4@v4.1.2)

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
