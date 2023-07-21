output "wordpress_instance_ip" {
  value = google_compute_instance.wordpress_instance.network_interface.0.access_config.0.nat_ip
}

output "mariadb_instance_ip" {
  value = google_compute_instance.mariadb_instance.network_interface.0.access_config.0.nat_ip
}
