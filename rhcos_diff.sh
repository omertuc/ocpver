#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

ARCH=${ARCH:-x86_64}
MAJ_MINOR=${MAJ_MINOR:-4.10}

DIFF_URL="https://releases-rhcos-art.cloud.privileged.psi.redhat.com/diff.html"

< "$SCRIPT_DIR"/"$MAJ_MINOR".json jq --slurp \
    --arg majmin "$MAJ_MINOR"\
    --arg arch "$ARCH"\
    --arg diff_url "$DIFF_URL"\
    '
    [.[:-1], .[1:]] 
    | transpose[] 
    | {
        "v1": .[0] | to_entries[0].value,
        "v2": .[1] | to_entries[0].value,
    }
    | "\($diff_url)?arch=\($arch)&first_release=\(.v1)&first_stream=releases%2Frhcos-\($majmin)&second_release=\(.v2)&second_stream=releases%2Frhcos-\($majmin)"' -r


