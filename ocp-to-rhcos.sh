#!/bin/bash

set -euo pipefail

MAJ_MINOR=${MAJ_MINOR:-"4.10"}

REPO=${REPO:-quay.io/openshift-release-dev/ocp-release}
ARCH=${ARCH:-x86_64}

MIN_Z=${MIN_Z:-1}
MAX_Z=${MAX_Z:-24}

PULL_SECRET_FILE=${PULL_SECRET:-"$HOME"/.docker/config.json}

RHCOS_INFO_URL="https://releases-rhcos-art.cloud.privileged.psi.redhat.com/storage/releases"

echo '['
for Z in $(seq "$MIN_Z" "$MAX_Z"); do

    OCP_VER="$MAJ_MINOR"."$Z"
    RHCOS_VER=$(oc adm --registry-config="$PULL_SECRET_FILE" release info "$REPO":"$OCP_VER"-"$ARCH" | \
		grep "machine-os " | \
		cut -d' ' -f4)

    if [[ "$MAJ_MINOR" == "4.10" && "$Z" == "18" ]]; then
        # https://coreos.slack.com/archives/C999USB0D/p1659628243464599
        KERNEL_VER=4.18.0-305.49.1.el8_4.x86_64
    elif [[ "$MAJ_MINOR" == "4.9" && "$Z" == "38" ]]; then
        # https://coreos.slack.com/archives/C999USB0D/p1659629295191159?thread_ts=1659628243.464599&cid=C999USB0D
        KERNEL_VER=4.18.0-305.49.1.el8_4.x86_64
    else
        KERNEL_VER=$(curl -sL "$RHCOS_INFO_URL"/rhcos-"$MAJ_MINOR"/"$RHCOS_VER"/"$ARCH"/commitmeta.json | jq '."ostree.linux"' -r)
    fi

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
