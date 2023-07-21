variable "account_id" {
  description = "Service account id."
  default = "terraform"
}

variable "display_name" {
  description = "Service account name."
  default = "terraform"
}

variable "key_filename" {
  description = "How to deploy the key and how to name it."
  default = "../ansible/service_account.json"
}

variable "gcp_project" {
  description = "The GCP project to deploy the runner into"
}