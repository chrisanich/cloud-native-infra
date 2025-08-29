// Module: k8s-node
// Purpose: Create one or more Kubernetes worker nodes on Hetzner Cloud.

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

variable "worker_count" {
  type        = number
  description = "Number of worker nodes to create"
}

// Create the worker nodes
resource "hcloud_server" "worker" {
  count       = var.worker_count
  name        = "w${count.index + 1}"
  server_type = var.server_type
  image       = "ubuntu-24.04"
  location    = var.region
  ssh_keys    = [var.ssh_key_name]

  network {
    network_id = var.network_id
    // no explicit ip = auto-assigned
  }

  labels = {
    role = "worker"
  }
}

// Output: list of worker IPs
output "ips" {
  value = [for w in hcloud_server.worker : w.ipv4_address]
}
