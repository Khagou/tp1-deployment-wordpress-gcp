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

variable "subnet_cidr" {
  description = "CIDR block for the subnetwork."
  default = "10.0.0.0/24"
}