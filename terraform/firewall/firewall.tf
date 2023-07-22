# firewall/firewall.tf

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

  source_ranges = var.firewall_source
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

  source_ranges = var.firewall_source
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
