output "network_id" {
  description = "The ID of the Hetzner Cloud network"
  value       = hcloud_network.main.id
}

output "network_name" {
  description = "The name of the Hetzner Cloud network"
  value       = hcloud_network.main.name
}

output "network_ip_range" {
  description = "The IP range (CIDR) of the Hetzner Cloud network"
  value       = hcloud_network.main.ip_range
}
