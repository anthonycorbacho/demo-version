#!/bin/bash
TAG="[$(basename -- "$0")]"

IMAGE_SRC_PATHS=( "servicea/" )
source ../build.sh


# build
if [[ "$IMAGE_CHANGE" == "true" ]]; then make; fi
