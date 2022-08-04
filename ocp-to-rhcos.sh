#!/bin/bash

set -euo pipefail

MAJ_MINOR=${MAJ_MINOR:-"4.10"}

REPO=${REPO:-quay.io/openshift-release-dev/ocp-release}
ARCH=${ARCH:-x86_64}

MIN_Z=${MIN_Z:-1}
MAX_Z=${MAX_Z:-26}

PULL_SECRET_FILE=${PULL_SECRET:-"$HOME"/.docker/config.json}

for Z in $(seq "$MIN_Z" "$MAX_Z"); do
	oc adm --registry-config="$PULL_SECRET_FILE" release info "$REPO":"$MAJ_MINOR"."$Z"-"$ARCH" |
		grep "machine-os " |
		cut -d' ' -f4 |
		awk '{printf "{\"'"$MAJ_MINOR.$Z"'\": \"" $1 "\"}\n"}'
done
