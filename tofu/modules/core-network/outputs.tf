output "network_id" {
  description = "The ID of the Hetzner network"
  value       = hcloud_network.main.id
}

output "network_name" {
  description = "The name of the Hetzner network"
  value       = hcloud_network.main.name
}
