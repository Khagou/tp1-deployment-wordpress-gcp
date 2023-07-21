variable "project_id" {
  description = "Google Cloud project ID."
  default     = "tp1-wordpress-mariadb"
}

variable "region" {
  description = "Google Cloud region."
  default     = "us-east1"
}

variable "gcp_zone" {
  type        = string
  default     = "us-east1-b"
  description = "The GCP zone to deploy the runner into."
}

variable "network_self_link" {
  description = "Self link of the Google Cloud network."
}

variable "subnet_self_link" {
  description = "Self link of the Google Cloud subnetwork."
}

variable "service_account_email" {
  description = "Service account email."
  default = "google_service_account.service_account.email"
}