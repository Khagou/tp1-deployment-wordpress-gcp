variable "gcp_project" {
  type        = string
  default     = "tp1-wordpress-mariadb"
  description = "The GCP project to deploy the runner into."
}
variable "gcp_zone" {
  type        = string
  default     = "us-east1-b"
  description = "The GCP zone to deploy the runner into."
}

variable "gcp_region" {
  type        = string
  default     = "us-east1"
  description = "The GCP region to deploy the runner into."
}

variable "network_self_link" {
  description = "Self link of the Google Cloud network."
  default = "google_compute_network.my_network.self_link"
}
variable "subnet_self_link" {
  description = "Self link of the Google Cloud network."
  default = "google_compute_subnetwork.my_subnetwork.self_link"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnetwork."
  default = "10.0.0.0/24"
}

variable "service_account_email" {
  description = "Service account email."
  default = google_service_account.service_account.email
}