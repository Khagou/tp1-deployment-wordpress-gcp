# network/network.tf

resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name          = "my-subnetwork"
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = var.subnet_cidr
}

output "network_name" {
  value = google_compute_network.my_network.name
}
output "network_self_link" {
  value = google_compute_network.my_network.self_link
}

output "subnet_name" {
  value = google_compute_subnetwork.my_subnetwork.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.my_subnetwork.self_link
}
