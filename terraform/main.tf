provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  scopes      = [ "https://www.googleapis.com/auth/cloud-platform" ]
}

resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name          = "my-subnetwork"
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "allow-internal-traffic" {
  name    = "allow-internal-traffic"
  network = google_compute_network.my_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["10.0.0.0/24"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.my_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "mariadb" {
  name    = "allow-mariadb"
  network = google_compute_network.my_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.0.0.0/24"]
}

resource "google_compute_firewall" "allow-http-https" {
  name    = "allow-http-https"
  network = google_compute_network.my_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_project_service" "iam" {
  project = var.gcp_project
  service = "iam.googleapis.com"
}

resource "google_service_account" "service_account" {
  account_id   = "terraform"
  display_name = "terraform"
}
resource "google_service_account_key" "service_account" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
resource "local_file" "service_account" {
    content  = base64decode(google_service_account_key.service_account.private_key)
    filename = "../ansible/service_account.json"
}

resource "google_project_iam_binding" "project" {
  project = var.gcp_project
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "oslogin" {
  project = var.gcp_project
  role    = "roles/compute.osLogin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "instanceAdmin" {
  project = var.gcp_project
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_compute_instance" "wordpress-instance" {
  name         = "wordpress-instance"
  machine_type = "e2-medium"
  zone         = var.gcp_zone
  tags         = ["wordpress", "ansible"]

  metadata = {
    # enable-oslogin = "TRUE"
  }
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
    network = google_compute_network.my_network
    subnetwork = google_compute_subnetwork.my_subnetwork.self_link
    access_config {
      // Autoriser l'accès par une adresse IP externe
    }
  }
}

resource "google_compute_instance" "mariadb-instance" {
  name         = "mariadb-instance"
  machine_type = "e2-medium"
  zone         = var.gcp_zone
  tags         = ["mariadb", "ansible"]

  metadata = {
    # enable-oslogin = "TRUE"
    enable-windows-ssh = "TRUE"
  }
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
    network = google_compute_network.my_network
    subnetwork = google_compute_subnetwork.my_subnetwork.self_link
    access_config {
      // Autoriser l'accès par une adresse IP externe
    }
  }
}

output "ip-wordpress-instance" {
  value = google_compute_instance.wordpress-instance.network_interface.0.access_config.0.nat_ip
}
output "ip-mariadb-instance" {
  value = google_compute_instance.mariadb-instance.network_interface.0.access_config.0.nat_ip
}

