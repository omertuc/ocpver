#!/bin/bash

set -euo pipefail

VER=${VER:-"4.10"}

REPO=${REPO:-quay.io/openshift-release-dev/ocp-release}
ARCH=${ARCH:-x86_64}

MIN_MINOR=1
MAX_MINOR=26

PULL_SECRET_FILE=${PULL_SECRET:-"$HOME"/.docker/config.json}

for i in $(seq $MIN_MINOR $MAX_MINOR); do
	oc adm --registry-config="$PULL_SECRET_FILE" release info "$REPO":4.10.26-"$ARCH" |\
        grep "machine-os " |\
        cut -d' ' -f4 |\
        awk '{printf "{\"'"$VER.$i"'\": \"" $1 "\"}\n"}'
done
