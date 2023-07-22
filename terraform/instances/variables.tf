variable "subnet_self_link" {
  description = "Self link of the Google Cloud subnetwork."
}

variable "service_account_email" {
  description = "email du compte de service"
}

variable "wordpress" {
  description = "Nom de l'instance avec wordpress"
}
variable "mariadb" {
  description = "Nom de l'instance avec maraidb"
}

variable "machine" {
  description = "Machine type"
}
