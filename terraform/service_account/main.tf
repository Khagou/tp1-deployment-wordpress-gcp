# service_account

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_service_account_key" "service_account" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "service_account_key" {
  content  = base64decode(google_service_account_key.service_account.private_key)
  filename = var.key_filename
}

resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "oslogin" {
  project = var.project_id
  role    = "roles/compute.osLogin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "instanceAdmin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

output "service_account_email" {
  value = google_service_account.service_account.email
}