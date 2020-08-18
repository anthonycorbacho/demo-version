#!/bin/bash

DIRTY_FILES=$(git status --porcelain | wc -l | tr -d " ")
if [[ "${DIRTY_FILES}" == "0" ]]; then
  export DIRTY_COMMIT="false"
  export DIRTY_COMMIT_POSTFIX=""
else
  export DIRTY_COMMIT="true"
  export DIRTY_COMMIT_POSTFIX="_dirty"
fi

GIT_CURRENT_USER=${GIT_CURRENT_USER:-}
if [[ "${GIT_CURRENT_USER}" == "" ]]; then
  GIT_CURRENT_USER=$(git config user.name | sed "s/ //g" | cut -d '@' -f 1)
  if [[ "${GIT_CURRENT_USER}" == "" ]]; then
    GIT_CURRENT_USER="Jenkins"
  fi
  export GIT_CURRENT_USER=${GIT_CURRENT_USER}
fi

export CURRENT_GIT_BRANCH_NAME="$(git symbolic-ref HEAD --short 2>/dev/null)"
if [ "$CURRENT_GIT_BRANCH_NAME" = "" ] ; then
  CURRENT_GIT_BRANCH_NAME="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
  export CURRENT_GIT_BRANCH_NAME=${CURRENT_GIT_BRANCH_NAME#remotes/origin/};
fi

# get changed files
if [[ "${DIRTY_COMMIT}" == "true" ]]; then
  # use branch name in local machine
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  TARGET_BRANCH="${GIT_BRANCH}"
else
  LOCAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$LOCAL_BRANCH" == "HEAD" ]]; then
    # in case of jenkins fetched branch, it uses `HEAD` so need to compare w/ `HEAD^1`
    TARGET_BRANCH="HEAD^1"
  else
    # otherwise use `latest` or `master` based on `${ENV}` for local, clean branch
    if [[ "$ENV" == "PROD" ]]; then
      TARGET_BRANCH="${GIT_BRANCH}"
    else
      TARGET_BRANCH="${GIT_BRANCH}"
    fi
  fi
fi

echo -e "${TAG} Target branch for file comparison: ${TARGET_BRANCH}"
changed_files=$(git diff --name-only ${TARGET_BRANCH} | grep -v package-lock.json)

# validate changed files exist
if [[ "${#changed_files}" == "0" ]]; then
  echo -e "${TAG} nothing changed"
  # close if `FORCE=false`
  if [[ "${FORCE}" == "false" ]]; then
    exit 0
  fi
fi

# print changed files
echo -e "${TAG} changed file names\n"
IMAGE_CHANGE="false"
for imageSrcPath in "${IMAGE_SRC_PATHS[@]}"; do
  echo -e "  PATH: ${imageSrcPath}"
  for filename in ${changed_files[@]}; do
    if [[ $filename == "${imageSrcPath}"* ]]; then
      IMAGE_CHANGE="true"
      echo -e "(modified)\t$filename "
      break
    else
      echo -e "(non-related)\t$filename "
    fi
  done

  if [[ "${IMAGE_CHANGE}" == "true" ]]; then
    break
  fi
done

echo -e ""
echo -e "${TAG} IMAGE_CHANGE: ${IMAGE_CHANGE}"
if [[ "${IMAGE_CHANGE}" == "false" ]] && [[ "$FORCE" == "false" ]]; then
  echo -e "${TAG} image files under '${IMAGE_SRC_PATHS}' not modified"
  exit 0
fi
