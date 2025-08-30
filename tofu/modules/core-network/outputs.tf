output "network_id" {
  value = hcloud_network.main.id
}

output "network_ip_range" {
  value = hcloud_network.main.ip_range
}

output "subnet_ip_range" {
  value = hcloud_network_subnet.main.ip_range
}

# Optional: export the name you passed in
output "network_name" {
  value = var.network_name
}
