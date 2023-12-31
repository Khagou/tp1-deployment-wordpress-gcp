# main.tf
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  scopes      = [ "https://www.googleapis.com/auth/cloud-platform" ]
}

module "network" {
  source       = "./network"
  subnet_cidr = var.subnet_cidr
}

module "firewall" {
  source           = "./firewall"
  network_self_link = module.network.network_self_link
  firewall_source = var.firewall_source
}
module "service_account" {
  source      = "./service_account"
  gcp_project = var.gcp_project
  key_filename = var.key_filename
  account_id   = var.account_id
  display_name = var.display_name
}

module "instances" {
  depends_on = [ module.network ]
  source               = "./instances"
  subnet_self_link     = module.network.subnet_self_link
  service_account_email = module.service_account.service_account_email
  mariadb = var.maraidb
  machine = var.machine
  wordpress = var.wordpress
}
