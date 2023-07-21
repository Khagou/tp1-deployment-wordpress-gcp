# main.tf

module "network" {
  source       = "./network/network.tf"
  project_id   = var.gcp_project
  region       = var.gcp_region
}

module "firewall" {
  source           = "./firewall/firewall.tf"
  network_self_link = module.network.network_self_link
  subnet_cidr       = var.subnet_cidr
  region            = var.gcp_region
}

module "instances" {
  source               = "./instances/instances.tf"
  project_id           = var.gcp_project
  region               = var.gcp_region
  zone                 = var.gcp_zone
  network_self_link    = module.network.network_self_link
  subnet_self_link     = module.network.subnet_self_link
  service_account_email = google_service_account.service_account.email
}
