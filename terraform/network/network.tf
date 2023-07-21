# network/network.tf

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

# variable "subnet_cidr" {
#   description = "CIDR block for the subnetwork."
#   default = "10.0.0.0/24"
# }

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
