# DVC Access SA
resource "google_service_account" "dos" {
  account_id = "dvc-object-storage"
}
resource "google_project_iam_member" "dos" {
  project = var.gcp_project_id
  role = google_project_iam_custom_role.dos.name
  member = "serviceAccount:${google_service_account.dos.email}"
}
resource "google_service_account_iam_policy" "dos-policy" {
  service_account_id = google_service_account.dos.name
  policy_data =  data.google_iam_policy.dos.policy_data
}
data "google_iam_policy" "dos" {
  binding {
    role = google_project_iam_custom_role.dos.name
    members = [ "serviceAccount:${google_service_account.dos.email}" ]
  }
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = ["principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool_provider.github-actions.workload_identity_pool_id}/attribute.repository/${var.current_repo}"]
  }
}
resource "google_project_iam_custom_role" "dos" {
  role_id = "dvc_object_storage"
  title = ""
  description = ""
  permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

# DVC Bucket
resource "google_storage_bucket" "dvc" {
  name = "${var.gcp_project_id}_dvc-objects"
  location = "us-west1"
}
