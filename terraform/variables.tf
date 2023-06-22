variable "gcp_project" {
  type        = string
  default     = "cursusm2i-maxence"
  description = "The GCP project to deploy the runner into."
}
variable "gcp_zone" {
  type        = string
  default     = "europe-west1-b"
  description = "The GCP zone to deploy the runner into."
}

variable "gcp_region" {
  type        = string
  default     = "europe-west1"
  description = "The GCP region to deploy the runner into."
}
