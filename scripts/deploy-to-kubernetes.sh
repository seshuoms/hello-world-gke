#!/bin/bash

# === CONFIGURE THESE ===
DEPLOYMENT_NAME="hello-world-deployment"
CONTAINER_NAME="hello-world"
IMAGE="us-east1-docker.pkg.dev/hello-world-458306/hello-repo/hello:latest"
NAMESPACE="default"

echo "📦 Updating Kubernetes Deployment..."
kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$IMAGE --namespace $NAMESPACE

echo "🔁 Waiting for rollout to finish..."
kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace $NAMESPACE

echo "✅ Deployment updated with new image: $IMAGE"
