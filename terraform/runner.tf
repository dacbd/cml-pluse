# cml-runner
resource "google_service_account" "cml-runner" {
  account_id = "cml-runner"
}
resource "google_project_iam_member" "cml-runner" {
  project = var.gcp_project_id
  role = google_project_iam_custom_role.cr.name
  #role = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.cml-runner.email}"
}

resource "google_service_account_iam_policy" "cml-runner-policy" {
  service_account_id = google_service_account.cml-runner.name
  policy_data =  data.google_iam_policy.cml-runner.policy_data
}
data "google_iam_policy" "cml-runner" {
  binding {
    role = google_project_iam_custom_role.cr.name
    members = [ "serviceAccount:${google_service_account.cml-runner.email}" ]
  }
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = ["principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool_provider.github-actions.workload_identity_pool_id}/attribute.repository/${var.current_repo}"]
  }
  #binding {
  #  role = "roles/iam.serviceAccountTokenCreator"
  #  members = [ "serviceAccount:${google_service_account.cml-runner.email}" ]
  #  #members = ["principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool_provider.github-actions.workload_identity_pool_id}/attribute.repository/${var.current_repo}"]
  #}
}
resource "google_project_iam_custom_role" "cr" {
  role_id = "cml_runner"
  title = "cml-runner"
  description = ""
  permissions = [
    "compute.disks.create",
    "compute.diskTypes.get",
    "compute.firewalls.create",
    "compute.firewalls.delete",
    "compute.globalOperations.get",
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.get",
    "compute.instances.list",
    "compute.instances.setMetadata",
    "compute.instances.setServiceAccount",
    "compute.instances.setTags",
    "compute.machineTypes.get",
    "compute.networks.get",
    "compute.networks.create",
    "compute.networks.updatePolicy",
    "compute.subnetworks.use",
    "compute.subnetworks.useExternalIp",
    "compute.zoneOperations.get",
    "compute.zones.list",
    "compute.zones.get", # gcpcc test
    "iam.serviceAccounts.actAs",
  ]
}