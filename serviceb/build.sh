#!/bin/bash
TAG="[$(basename -- "$0")]"

IMAGE_SRC_PATHS=( "serviceb/" )
source ../build.sh


# build
if [[ "$IMAGE_CHANGE" == "true" ]]; then make; fi
