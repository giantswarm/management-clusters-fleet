#! /usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

ARGOCD_REPOSITORY="https://github.com/argoproj/argo-cd.git"
ARGOCD_VERSION=${1:-master}
SRCROOT="$( CDPATH='' cd -- "$(dirname "$0")/.." && pwd -P )"
WORK_DIR=$(mktemp -d -t ci-XXXXXXXXXX)

KUSTOMIZE=kustomize

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

set -x

${KUSTOMIZE} version

git clone --quiet --depth 1 --branch ${ARGOCD_VERSION} ${ARGOCD_REPOSITORY} ${WORK_DIR}
cd ${WORK_DIR}

mkdir -p ${SRCROOT}/manifests/bases/upstream-argocd
echo "${AUTOGENMSG}" > "${SRCROOT}/manifests/bases/upstream-argocd/install.yaml"
${KUSTOMIZE} build "manifests/cluster-install" >> "${SRCROOT}/manifests/bases/upstream-argocd/install.yaml"

cd ${SRCROOT}
rm $WORK_DIR -Rf
