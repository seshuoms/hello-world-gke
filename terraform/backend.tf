terraform {
  backend "gcs" {
    bucket  = "gke-terraform-state-bucket"
    prefix  = "state/hello-world-gke"
  }
}
