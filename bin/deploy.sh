#!/bin/bash -e

# NOTE Do **not** set -x here as that would expose sensitive credentials
#      in the Travis build logs.

# tag has to be in the form "2016-08-30" (optionally with a ".1" after for same day deploys)
if [[ "$1" == "prod" ]] && [[ "$TRAVIS_TAG" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}(\.[0-9])?$ ]]; then
  HEROKU_APP="$HEROKU_PROD_APP"
elif [[ "$1" == "stage" ]] && [[ "${TRAVIS_PULL_REQUEST}" == "false" ]] && [[ "$TRAVIS_BRANCH" == "master" ]]; then
  HEROKU_APP="$HEROKU_STAGE_APP"
else
  echo "Nothing to deploy"
  exit 0
fi

DOCKER_TAG="$DOCKER_REGISTRY/$HEROKU_APP/$HEROKU_PROC_TYPE"
echo "Pushing $DOCKER_TAG"
docker login -u "$HEROKU_EMAIL" -p "$HEROKU_API_KEY" "$DOCKER_REGISTRY"
docker tag standup_irc "$DOCKER_TAG"
docker push "$DOCKER_TAG"
