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
  network_self_link = var.network_self_link
  subnet_cidr       = var.subnet_cidr
  # region            = var.gcp_region
}


module "instances" {
  depends_on = [ module.network ]
  source               = "./instances"
  project_id           = var.gcp_project
  region               = var.gcp_region
  # zone                 = var.gcp_zone
  network_self_link    = module.network.network_self_link
  subnet_self_link     = module.network.subnet_self_link
  # service_account_email = module.service_account.members
}
