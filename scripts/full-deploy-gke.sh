#!/bin/bash

# === CONFIGURE THESE ===
PROJECT_ID="hello-world-458306"
REGION="us-east1"
REPO_NAME="hello-repo"
IMAGE_NAME="hello"
TAG="latest"
DEPLOYMENT_NAME="hello-world-deployment"
CONTAINER_NAME="hello-world-container"
NAMESPACE="default"

FULL_IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG"

echo "🔐 Logging in to GCP..."
gcloud auth activate-service-account --key-file=sa-key.json
gcloud config set project $PROJECT_ID

echo "📦 Creating Artifact Registry repo if not exists..."
gcloud artifacts repositories create $REPO_NAME \
  --repository-format=docker \
  --location=$REGION \
  --description="Hello World Docker repo" || echo "✅ Repo may already exist."

echo "🔑 Configuring Docker to authenticate with Artifact Registry..."
gcloud auth configure-docker $REGION-docker.pkg.dev

echo "🐳 Building Docker image..."
docker build -t $FULL_IMAGE .

echo "🚀 Pushing image to Artifact Registry..."
docker push $FULL_IMAGE

echo "📦 Updating Kubernetes Deployment..."
kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$FULL_IMAGE --namespace $NAMESPACE

echo "🔁 Waiting for rollout to finish..."
kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace $NAMESPACE

echo "✅ Full deployment complete. Your app is running with the new image!"
