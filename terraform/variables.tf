variable "gcp_project" {
  type        = string
  default     = "test-retry" # Change me
  description = "The GCP project to deploy the runner into."
}
variable "gcp_zone" {
  type        = string
  default     = "us-east1-b" # Change me if you need
  description = "The GCP zone to deploy the runner into."
}

variable "gcp_region" {
  type        = string
  default     = "us-east1" # Change me if you need
  description = "The GCP region to deploy the runner into."
}

variable "wordpress" {
  description = "Wordpress instance name"
  default = "wordpress-instance" # Change me if you need
}

variable "maraidb" {
  description = "Mariadb instance name"
  default = "mariadb-instance" # Change me if you need
}
variable "machine" {
  description = "Machine type"
  default = "e2-medium" # Change me if you need
}

variable "account_id" {
  description = "Service account id."
  default = "terraform" # Change me if you need
}

variable "display_name" {
  description = "Service account name."
  default = "terraform" # Change me if you need
}

variable "key_filename" {
  description = "How to deploy the key and how to name it."
  default = "../ansible/service_account.json" # Change me if you need
}

variable "subnet_cidr" {
  description = "CIDR block for the subnetwork."
  default = "10.0.0.0/24" # Change me if you need
}
variable "firewall_source" {
  description = "source block for the firewall."
  default = ["10.0.0.0/24"] # Change me if you need
}