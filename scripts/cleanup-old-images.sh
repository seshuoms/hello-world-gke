#!/bin/bash
# Script: cleanup-old-images.sh
# Description: Deletes all but the latest 5 images from Artifact Registry

REPO=hello-repo
PROJECT_ID=hello-world-458306
REGION=us-east1
IMAGE=hello

gcloud artifacts docker images list $REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$IMAGE --format='get(version)' | sort -r | sed -n '6,$p' | while read version; do
  echo "Deleting version: $version"
  gcloud artifacts docker images delete "$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$IMAGE@$version" --quiet
done
