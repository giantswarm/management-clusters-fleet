#! /usr/bin/env bash
set -x
set -o errexit
set -o nounset
set -o pipefail

ARGOCD_REPOSITORY="https://github.com/argoproj/argo-cd.git"
ARGOCD_VERSION=${1:-master}
SRCROOT="$( CDPATH='' cd -- "$(dirname "$0")/.." && pwd -P )"
WORK_DIR=$(mktemp -d -t ci-XXXXXXXXXX)

KUSTOMIZE=kustomize

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

IMAGE_NAMESPACE="${IMAGE_NAMESPACE:-quay.io/giantswarm}"
IMAGE_TAG="${ARGOCD_VERSION:-latest}"

${KUSTOMIZE} version

git clone --depth 1 --branch ${ARGOCD_VERSION} ${ARGOCD_REPOSITORY} ${WORK_DIR}
cd ${WORK_DIR}

cd manifests/base
${KUSTOMIZE} edit set image quay.io/argoproj/argocd=${IMAGE_NAMESPACE}/argocd:${IMAGE_TAG} 
${KUSTOMIZE} edit set namespace argocd
cd -

sed -i "/dex/d" manifests/base/kustomization.yaml

echo "${AUTOGENMSG}" > "${SRCROOT}/build/install.yaml"
${KUSTOMIZE} build "manifests/cluster-install" >> "${SRCROOT}/build/install.yaml"

cd -
rm $WORK_DIR -Rf
