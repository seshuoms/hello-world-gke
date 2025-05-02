#!/bin/bash
# Script: deploy-gke.sh
# Description: Automate GCS bucket creation and Terraform apply for GKE setup

set -e

PROJECT_ID=hello-world-458306
REGION=us-east1
BUCKET_NAME=gke-terraform-state-bucket

echo "🔹 Creating GCS bucket (if not exists)..."
gsutil mb -p $PROJECT_ID -l $REGION gs://$BUCKET_NAME || echo "✅ Bucket already exists"

echo "🔹 Initializing Terraform..."
cd terraform
terraform init

echo "🔹 Applying Terraform (may take a few minutes)..."
terraform apply -auto-approve -var="project_id=$PROJECT_ID" -var="region=$REGION"

echo "✅ GKE Cluster and Artifact Registry should now be provisioned."
