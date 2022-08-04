#!/bin/bash

set -euxo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

REPO=${REPO:-quay.io/openshift-release-dev/ocp-release}
ARCH=${ARCH:-x86_64}
MIN_Z=${MIN_Z:-1}

MAJ_MINOR="4.10" MAX_Z=26 "$SCRIPT_DIR"/ocp-to-rhcos.sh > 4.10.json
MAJ_MINOR="4.9"  MAX_Z=45 "$SCRIPT_DIR"/ocp-to-rhcos.sh > 4.9.json
MAJ_MINOR="4.8"  MAX_Z=47 "$SCRIPT_DIR"/ocp-to-rhcos.sh > 4.8.json

