#!/usr/bin/env bash

# Scriptdir is the directory in which this script resides
SCRIPTDIR="$(pwd)"

# DOTENV is the gitignored .env file for the current user
DOTENV="$SCRIPTDIR/.env"

# the KEYSDIR is the gitignored directory for sensitive data
KEYSDIR="creds"
test -d "$KEYSDIR" || mkdir "$KEYSDIR"
grep -s -q "$KEYSDIR" .gitignore || echo "${KEYSDIR}/" >> .gitignore


# set the kubectl context to where the secret is hosted
echo "*** Setting up kubectl context ***"
KUBECONFIGFILE="${KEYSDIR}/kubeconfig"
KUBECLUSTER="infra-platform-v2"
KUBECONFIG="$KUBECONFIGFILE" gcloud container clusters get-credentials "$KUBECLUSTER" --zone "europe-west1-b" --project cytoreason

# get the credentials for the service agent which will be used to authenticate
# store them in the gitignored directory:
GOOGLE_APPLICATION_CREDENTIALS="${KEYSDIR}/credentials.json"
KUBECONFIG="$KUBECONFIGFILE" kubectl get secret ci-image-builder -o 'go-template={{index .data "credentials.json" }}' | base64 -d > "$GOOGLE_APPLICATION_CREDENTIALS"

rm -f "$DOTENV"

echo "*** Creating gitignored $DOTENV ***"
echo "GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}" >> "$DOTENV"
echo "*** $DOTENV created ***"
