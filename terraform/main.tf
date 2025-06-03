provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file(var.credentials_file)
}

resource "google_container_cluster" "primary" {
  name     = "nodejs-mongodb-cluster"
  location = var.region
  deletion_protection = var.deletion_protection
  initial_node_count = 2
  node_config {
    machine_type = "e2-medium"
  }
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "nodejs-mongodb-repo"
  format        = "DOCKER"
}

resource "google_service_account" "github_actions" {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}

resource "google_project_iam_member" "github_actions" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "service_account_key" {
  value     = google_service_account.github_actions.email
  sensitive = true
}
