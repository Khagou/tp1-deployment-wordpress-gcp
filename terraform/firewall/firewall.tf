# firewall/firewall.tf

variable "network_self_link" {
  description = "Self link of the Google Cloud network."
}

variable "gcp_region" {
  type        = string
  default     = "us-east1"
  description = "The GCP region to deploy the runner into."
}

variable "subnet_cidr" {
  description = "CIDR block for the subnetwork."
  default = "10.0.0.0/24"
}

provider "google" {
  region = var.region
}

resource "google_compute_firewall" "allow_internal_traffic" {
  name    = "allow-internal-traffic"
  network = var.network_self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = [var.subnet_cidr]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "mariadb" {
  name    = "allow-mariadb"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = [var.subnet_cidr]
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
