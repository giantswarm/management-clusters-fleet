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

build/provider: $(MANIFESTS)
	@echo "====> $@"
	mkdir -p $@
	@$(MAKE) bootstrap/aws.yaml
	@$(MAKE) bootstrap/aws-test.yaml
	@$(MAKE) bootstrap/aws-china.yaml
	@$(MAKE) bootstrap/aws-china-test.yaml
	@$(MAKE) bootstrap/azure.yaml
	@$(MAKE) bootstrap/azure-test.yaml
	@$(MAKE) bootstrap/kvm.yaml
	@$(MAKE) bootstrap/kvm-test.yaml
	@$(MAKE) bootstrap/vmware.yaml
	@$(MAKE) bootstrap/vmware-test.yaml

bootstrap/%.yaml: $(MANIFESTS)
	@echo "====> $@"
	echo "$(AUTOGENMSG)" > $@
	$(KUSTOMIZE) build manifests/provider/$* >> $@
