#!/bin/bash

OWNER="SpritStar"
REPO="test"
ENVIRONMENT="prod"
# TOKEN="ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"


RUN_ID=$( gh run list --repo ${OWNER}/${REPO} --json status,databaseId --jq '.[] | select(.status=="waiting") | .databaseId' | head -1 )
if [ -z "${RUN_ID}" ]; then
    echo "found no RUN_ID"
    exit 1
fi
echo "run_id: ${RUN_ID}"

ENVIRONMENT_ID=$( gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/${OWNER}/${REPO}/environments/${ENVIRONMENT} | jq .id )
if [ -z "${ENVIRONMENT_ID}" ]; then
    echo "found no ENVIRONMENT_ID"
    exit 1
fi
echo "environment_id: ${ENVIRONMENT_ID}"

curl -L -X POST -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/${OWNER}/${REPO}/actions/runs/${RUN_ID}/pending_deployments \
    -d '{"environment_ids":['$ENVIRONMENT_ID'],"state":"approved","comment":"Ship it"}'
