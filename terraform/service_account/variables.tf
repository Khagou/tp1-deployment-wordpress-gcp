variable "gcp_project" {
  description = "The GCP project to deploy the runner into."
}
variable "account_id" {
  description = "Service account id."
}

variable "display_name" {
  description = "Service account name."
}

variable "key_filename" {
  description = "How to deploy the key and how to name it."
}