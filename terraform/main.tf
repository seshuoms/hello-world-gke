provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "hello_repo" {
  provider = google
  location = var.region
  repository_id = "hello-repo"
  format = "DOCKER"
  description = "Hello World Docker Repo"
}

resource "google_container_cluster" "primary" {
  name     = "hello-cluster"
  location = var.region
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_type = "pd-standard"
  }
}
