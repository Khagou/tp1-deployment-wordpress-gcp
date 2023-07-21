# instances/instances.tf

# variable "project_id" {
#   description = "Google Cloud project ID."
#   default     = "tp1-wordpress-mariadb"
# }

# variable "region" {
#   description = "Google Cloud region."
#   default     = "us-east1"
# }

# variable "gcp_zone" {
#   type        = string
#   default     = "us-east1-b"
#   description = "The GCP zone to deploy the runner into."
# }

# variable "network_self_link" {
#   description = "Self link of the Google Cloud network."
# }

# variable "subnet_self_link" {
#   description = "Self link of the Google Cloud subnetwork."
# }

# variable "service_account_email" {
#   description = "Service account email."
# }
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

resource "google_compute_instance" "wordpress_instance" {
  name         = "wordpress-instance"
  machine_type = "e2-medium"
  # zone         = var.gcp_zone
  tags         = ["wordpress", "ansible"]


  service_account {
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {
      # Autoriser l'accès par une adresse IP externe
    }
  }
}

resource "google_compute_instance" "mariadb_instance" {
  name         = "mariadb-instance"
  machine_type = "e2-medium"
  # zone         = var.gcp_zone
  tags         = ["mariadb", "ansible"]


  service_account {
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {
      # Autoriser l'accès par une adresse IP externe
    }
  }
}

output "wordpress_instance_ip" {
  value = google_compute_instance.wordpress_instance.network_interface.0.access_config.0.nat_ip
}

output "mariadb_instance_ip" {
  value = google_compute_instance.mariadb_instance.network_interface.0.access_config.0.nat_ip
}
