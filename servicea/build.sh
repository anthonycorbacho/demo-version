#!/bin/bash
TAG="[$(basename -- "$0")]"

IMAGE_SRC_PATHS=( "servicea/" )
source ../build_common.sh


# build
if [[ "$IMAGE_CHANGE" == "true" ]]; then make; fi
