variable "account_id" {
  description = "Service account id."
  default = "terraform"
}

variable "display_name" {
  description = "Service account name."
  default = "terraform"
}
variable "gcp_project" {
  description = "Google Cloud project ID."
  default     = "tp1-wordpress-mariadb"
}

variable "key_filename" {
  description = "Chemin et nom de la cle."
  default = "../ansible/service_account.json"
}