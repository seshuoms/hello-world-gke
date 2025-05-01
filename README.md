# Hello World Spring Boot on GKE

## 📦 Technologies Used
- Spring Boot (REST API)
- Docker
- Google Cloud Artifact Registry
- Google Kubernetes Engine (GKE)
- GitHub Actions (CI/CD)

## 🛠️ Setup Instructions

### 1. Prerequisites
- GCP project with billing enabled
- IAM with permissions to use GKE, Artifact Registry
- GitHub repository
- Docker & Gradle installed locally

### 2. GCP Setup

- Enable APIs: GKE, Artifact Registry
- Create Artifact Registry:
  ```bash
  gcloud artifacts repositories create hello-repo \
    --repository-format=docker --location=us-east1
  ```

- Create GKE cluster:
  ```bash
  gcloud container clusters create hello-cluster \
    --num-nodes=1 --region=us-east1 --disk-type=pd-standard
  ```

### 3. GitHub Setup

- Add a secret named `GCP_SA_KEY` to GitHub (base64 of your GCP JSON key)
- Push code to `main` branch

### 4. CI/CD Flow

- On push to main:
  - Docker image is built and pushed to Artifact Registry
  - Kubernetes deployment applied via `kubectl apply -f deployment.yaml`

## 🌐 Access App

After deploying:
```bash
kubectl get svc hello-service
```

Open `http://<EXTERNAL-IP>` in browser.
