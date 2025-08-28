terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
  }
}

resource "hcloud_network" "main" {
  name     = var.network_name
  ip_range = var.network_cidr
}
