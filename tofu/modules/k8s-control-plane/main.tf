// Module: k8s-control-plane
// Purpose: Create one Kubernetes control-plane node on Hetzner Cloud.

variable "region" {
  type        = string
  description = "Hetzner region (fsn1, nbg1, hel1)"
}

variable "server_type" {
  type        = string
  description = "Hetzner server type (e.g., cpx21, cpx31)"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name registered in Hetzner"
}

variable "network_id" {
  type        = string
  description = "Hetzner network ID (from core-network module)"
}

variable "private_ip" {
  type        = string
  description = "Fixed private IP for control-plane node (e.g., 10.0.0.10)"
}

resource "hcloud_server" "cp" {
  name        = "cp"
  server_type = var.server_type
  image       = "ubuntu-24.04"
  location    = var.region
  ssh_keys    = [var.ssh_key_name]
 
  network {
    network_id = var.network_id
    ip         = var.private_ip
  }
  
  labels = {
    role = "control-plane"
  }
}

output "ip" {
  value       = hcloud_server.cp.ipv4_address
}
