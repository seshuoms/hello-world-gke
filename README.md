# 🚀 Hello World GKE Deployment Guide

This project demonstrates a complete CI/CD pipeline for deploying a Spring Boot application to **Google Kubernetes Engine (GKE)** using **Docker**, **GitHub Actions**, **Terraform**, and **Artifact Registry**. It supports multiple environments (`dev`, `stage`, `prod`) and includes:

- ✅ Kubernetes Ingress + HTTPS
- ✅ ConfigMap and Secret support
- ✅ Auto-cleanup of old Docker images
- ✅ Environment-aware GitHub Actions

---

## 📁 Project Structure

```bash
.
├── .github/workflows/            # GitHub Actions pipeline
├── k8s/                          # Kubernetes manifests
│   ├── deployment-dev.yaml
│   ├── deployment-stage.yaml
│   ├── deployment-prod.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── ingress.yaml
│   └── managed-cert.yaml
├── scripts/
│   ├── deploy-gke.sh             # Automates GCS + Terraform apply
│   └── cleanup-old-images.sh     # Keeps only latest 5 Docker images
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── backend.tf
└── README.md
```

---

## 🔧 Prerequisites

- GCP project with billing enabled
- Enabled APIs:
  - Kubernetes Engine
  - Artifact Registry
  - Compute Engine
- GitHub repo (add required secrets)

---

## 🔐 GitHub Secrets

| Secret Name | Purpose |
|-------------|---------|
| `GCP_SA_KEY` | Base64 or raw JSON of GCP service account key with roles: `container.admin`, `artifactregistry.writer` |
| `GCP_PROJECT_ID` | Your GCP project ID |

---

## 🚀 Setup & Deployment

### 1. Provision GKE & Artifact Registry via Terraform

```bash
chmod +x scripts/deploy-gke.sh
./scripts/deploy-gke.sh
```

This will:
- Create GCS bucket (if needed)
- Run `terraform init && apply` using values from `variables.tf`
- Set up `hello-cluster` and `hello-repo`

---

### 2. Push Code to GitHub

Pushing to:
- `dev` → deploys `k8s/deployment-dev.yaml`
- `stage` → deploys `k8s/deployment-stage.yaml`
- `main` → deploys `k8s/deployment-prod.yaml`

Each build:
- Builds a Docker image with the branch name as tag
- Pushes it to Artifact Registry
- Deploys to GKE using branch-specific manifest

---

### 3. Enable Ingress & TLS (optional but recommended)

#### Create static IP & DNS

```bash
gcloud compute addresses create hello-world-ip --global
```

Point your domain (e.g., `hello.example.com`) to this IP in your DNS.

#### Apply Kubernetes resources

```bash
kubectl apply -f k8s/
```

This includes:
- `Ingress` with TLS
- `ManagedCertificate` (GKE HTTPS)
- `ConfigMap` and `Secret`

---

### 4. Clean Up Old Images

```bash
chmod +x scripts/cleanup-old-images.sh
./scripts/cleanup-old-images.sh
```

This keeps only the 5 most recent images in Artifact Registry.

---

## ✅ Notes

- Edit values like `DB_PASSWORD` and domain name in `k8s/secret.yaml` and `ingress.yaml`
- Replace `hello.example.com` with your real domain
- Configure Cloud DNS or external provider to map your domain to the static IP

---

## 📞 Support

Need help? Open an issue or ping me on GitHub.

