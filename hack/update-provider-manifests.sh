#! /usr/bin/env bash
set -x
set -o errexit
set -o nounset
set -o pipefail

SRCROOT="$( CDPATH='' cd -- "$(dirname "$0")/.." && pwd -P )"

KUSTOMIZE=kustomize

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

$KUSTOMIZE version

for provider in $(ls manifests/provider); do
  echo "${AUTOGENMSG}" > "${SRCROOT}/build/${provider}-mc-fleet.yaml"
  ${KUSTOMIZE} build ${SRCROOT}/manifests/provider/${provider} >> "${SRCROOT}/build/${provider}-mc-fleet.yaml"
done

