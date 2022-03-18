output "Workload_Identity_Provider" {
  value = google_iam_workload_identity_pool_provider.github-actions.name
}
output "DVC_bucket" {
  value = google_storage_bucket.dvc.self_link
}
output "DVC_service_account" {
  value = google_service_account.dos.email
}
output "CML-runner_service_account" {
  value = google_service_account.cml-runner.email
}
