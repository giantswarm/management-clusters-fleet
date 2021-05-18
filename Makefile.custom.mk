AUTOGENMSG := \# This is an auto-generated file. DO NOT EDIT

KUSTOMIZE := kustomize

MANIFESTS := $(shell find manifests)

.PHONY: all
all: build/argocd build/provider

.PHONY: build/argocd
build/argocd: ARGOCD_VERSION=v2.0.1
build/argocd:
	@echo "====> $@"
	./hack/update-argocd-manifests.sh $(ARGOCD_VERSION)
	echo "$(AUTOGENMSG)" > build/argocd/install.yaml
	$(KUSTOMIZE) build manifests/argocd >> build/argocd/install.yaml

build/provider: $(MANIFESTS)
	@echo "====> $@"
	mkdir -p $@
	@$(MAKE) build/provider/aws.yaml
	@$(MAKE) build/provider/aws-test.yaml
	@$(MAKE) build/provider/azure.yaml
	@$(MAKE) build/provider/azure-test.yaml
	@$(MAKE) build/provider/kvm.yaml
	@$(MAKE) build/provider/kvm-test.yaml
	@$(MAKE) build/provider/vmware.yaml
	@$(MAKE) build/provider/vmware-test.yaml

build/provider/%.yaml: $(MANIFESTS)
	@echo "====> $@"
	echo "$(AUTOGENMSG)" > $@
	$(KUSTOMIZE) build manifests/provider/$* >> $@
