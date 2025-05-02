#!/bin/bash

# === CONFIGURE THESE ===
PROJECT_ID="hello-world-458306"
REGION="us-east1"
REPO_NAME="hello-repo"
IMAGE_NAME="hello"
TAG="latest"

echo "🔐 Logging in to GCP..."
gcloud auth login
gcloud config set project $PROJECT_ID

echo "📦 Creating Artifact Registry repo if not exists..."
gcloud artifacts repositories create $REPO_NAME \
  --repository-format=docker \
  --location=$REGION \
  --description="Hello World Docker repo" || echo "✅ Repo may already exist."

echo "🔑 Configuring Docker to authenticate with Artifact Registry..."
gcloud auth configure-docker $REGION-docker.pkg.dev

echo "🐳 Building Docker image..."
docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG .

echo "🚀 Pushing image to Artifact Registry..."
docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG

echo "✅ Done. You can now use this image in your Kubernetes deployment."
