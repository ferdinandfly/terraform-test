resource "google_project_service" "project" {
  project = var.project
  service = "container.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "artifactregistry" {
  project = var.project
  service = "artifactregistry.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloudbuild" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloudreourcemanager" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.project
  location      = var.location
  repository_id = "app"
  format        = "DOCKER"
  description   = "Docker repository"

  depends_on = [google_project_service.artifactregistry]
}

resource "google_service_account" "default" {
  account_id   = "gke-service-account"
  display_name = "Service Account"
}

resource "google_artifact_registry_repository_iam_member" "repo-iam" {
  provider = google-beta
  project       = var.project
  location = google_artifact_registry_repository.docker_repo.location
  repository = google_artifact_registry_repository.docker_repo.name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.default.email}"
}


resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = var.location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  deletion_protection      = false
  initial_node_count       = 1
  depends_on               = [google_project_service.project]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name           = "my-node-pool"
  location       = google_container_cluster.primary.location
  node_locations = ["europe-west1-b"]# without this, it  will create a container for each region
  cluster        = google_container_cluster.primary.name
  node_count     = 1
  autoscaling {
    total_max_node_count = 2
    total_min_node_count = 1
    location_policy      = "ANY"
  }
  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_compute_address" "ip_address" {
  name= "app-ip"
}

output "ip_address" {
  value = google_compute_address.ip_address.address
}
