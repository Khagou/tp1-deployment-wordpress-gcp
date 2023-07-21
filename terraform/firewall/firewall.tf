# firewall/firewall.tf

# variable "network_self_link" {
#   description = "Self link of the Google Cloud network."
# }

# variable "gcp_region" {
#   type        = string
#   default     = "us-east1"
#   description = "The GCP region to deploy the runner into."
# }

# variable "subnet_cidr" {
#   description = "CIDR block for the subnetwork."
#   default = "10.0.0.0/24"
# }

resource "google_compute_firewall" "allow_internal_traffic" {
  name    = "allow-internal-traffic"

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

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "mariadb" {
  name    = "allow-mariadb"

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.0.0.0/24"]
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
