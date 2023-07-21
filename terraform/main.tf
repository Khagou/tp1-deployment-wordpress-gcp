# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  scopes      = [ "https://www.googleapis.com/auth/cloud-platform" ]
}

module "network" {
  source       = "./network"
}

module "firewall" {
  source           = "./firewall"
  network_self_link = module.network.network_self_link
}
module "service_account" {
  source      = "./service_account"
  project = var.gcp_project
}

module "instances" {
  depends_on = [ module.network ]
  source               = "./instances"
  project_id           = var.gcp_project
  region               = var.gcp_region
  network_self_link    = module.network.network_self_link
  subnet_self_link     = module.network.subnet_self_link
  service_account_email = module.service_account.service_account_email
}
