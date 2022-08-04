#!/bin/bash

set -euo pipefail

MAJ_MINOR=${MAJ_MINOR:-"4.10"}

REPO=${REPO:-quay.io/openshift-release-dev/ocp-release}
ARCH=${ARCH:-x86_64}

MIN_Z=${MIN_Z:-1}
MAX_Z=${MAX_Z:-3}

PULL_SECRET_FILE=${PULL_SECRET:-"$HOME"/.docker/config.json}

echo '['
for Z in $(seq "$MIN_Z" "$MAX_Z"); do
    OCP_VER="$MAJ_MINOR"."$Z"
    RHCOS_VER=$(oc adm --registry-config="$PULL_SECRET_FILE" release info "$REPO":"$OCP_VER"-"$ARCH" | \
		grep "machine-os " | \
		cut -d' ' -f4)

    KERNEL_VER=$(curl -sL https://releases-rhcos-art.cloud.privileged.psi.redhat.com/storage/releases/rhcos-4.10/410.84.202202251620-0/x86_64/commitmeta.json | jq '."ostree.linux"' -r)

    FINAL=$(jq -n -c --arg ocp_ver "$OCP_VER" --arg rhcos_ver "$RHCOS_VER" --arg kernel_ver "$KERNEL_VER" '
        {
            "ocp_version": $ocp_ver,
            "rhcos_ver": $rhcos_ver,
            "kernel_ver": $kernel_ver
        }')

    if [[ "$Z" == "$MAX_Z" ]]; then
        printf '\t%s\n' "$FINAL"
    else
        printf '\t%s,\n' "$FINAL"
    fi
done
echo ']'
