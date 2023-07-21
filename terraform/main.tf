# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  scopes      = [ "https://www.googleapis.com/auth/cloud-platform" ]
}

module "network" {
  source       = "./network"
  project_id   = var.gcp_project
  region       = var.gcp_region
}

module "firewall" {
  source           = "./firewall"
  network_self_link = module.network.network_self_link
  subnet_cidr       = var.subnet_cidr
  # region            = var.gcp_region
}
module "service_account" {
  source = "./service_account"
  account_id = "terraform"
  display_name = "terraform"
  service_account_id = google_service_account.service_account.name
  public_key_type = "TYPE_X509_PEM_FILE"
  content  = base64decode(google_service_account_key.service_account.private_key)
  filename = "../ansible/service_account.json"
}

module "instances" {
  source               = "./instances"
  project_id           = var.gcp_project
  region               = var.gcp_region
  # zone                 = var.gcp_zone
  network_self_link    = module.network.network_self_link
  subnet_self_link     = module.network.subnet_self_link
  service_account_email = google_service_account.service_account.email
}
