# instances/instances.tf


resource "google_compute_instance" "wordpress_instance" {
  name         = "wordpress-instance"
  machine_type = "e2-medium"
  # zone         = var.gcp_zone
  tags         = ["wordpress", "ansible"]


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
  # zone         = var.gcp_zone
  tags         = ["mariadb", "ansible"]


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