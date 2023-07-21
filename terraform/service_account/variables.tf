variable "project_id" {
  description = "Google Cloud project ID."
  default     = "tp1-wordpress-mariadb"
}

variable "account_id" {
  description = "Service account id."
  default     = "terraform"
}

variable "display_name" {
  description = "Service account display name."
  default     = "terraform"
}

variable "key_filename" {
  description = "Chemin de la cle du service account."
  default     = "../ansible/service_account.json"
}
