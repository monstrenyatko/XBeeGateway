#!/bin/bash

set -e
set -x

exiterr() { echo "Error: ${1}" >&2; exit 1; }

function abs_path {
    if [[ -d "$1" ]]
    then
        pushd "$1" >/dev/null
        pwd
        popd >/dev/null
    elif [[ -e $1 ]]
    then
        pushd "$(dirname "$1")" >/dev/null
        echo "$(pwd)/$(basename "$1")"
        popd >/dev/null
    else
        echo "$1" does not exist! >&2
        return 1
    fi
}

SRC_PATH=$(abs_path $1)
if [ -z "$SRC_PATH" ]; then
    exiterr "$1 does not exist!"
fi

export RPXC_IMAGE=monstrenyatko/rpi-cross-compiler
export RPXC_ARGS="-v $SRC_PATH:/source"

docker run --rm $RPXC_IMAGE > ./rpxc
chmod +x ./rpxc

./rpxc -- /source/build/docker_raspberrypi/run.sh
