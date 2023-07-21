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

resource "google_compute_instance" "wordpress_instance" {
  name         = "wordpress-instance"
  machine_type = "e2-medium"
  zone         = var.gcp_zone
  tags         = ["wordpress", "ansible"]

  metadata = {
    # enable-oslogin = "TRUE"
  }
  service_account {
    email  = var.service_account_email
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
  zone         = var.gcp_zone
  tags         = ["mariadb", "ansible"]

  metadata = {
    # enable-oslogin = "TRUE"
    enable-windows-ssh = "TRUE"
  }
  service_account {
    email  = var.service_account_email
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
