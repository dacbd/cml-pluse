provider "google" {
  project = var.gcp_project_id
  region = "us-west1"
}
provider "google-beta" {
  project = var.gcp_project_id
  region = "us-west1"
}


data "google_project" "project" {}

resource "google_iam_workload_identity_pool" "pool" {
  provider = google-beta
  #project = var.gcp_project_id
  workload_identity_pool_id = "gh-actions-pool"
}
# https://github.com/google-github-actions/auth#setup
# https://cloud.google.com/iam/docs/workload-identity-federation?_ga=2.178799844.-1125913399.1642444018#mapping
resource "google_iam_workload_identity_pool_provider" "github-actions" {
  provider = google-beta
  #project = var.gcp_project_id
  workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.actor" = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}




