terraform {
  required_providers {
    hcloud = {
      source = "hertznercloud/hcloud"
      version = "~ 1.45" 
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# Create a network (VPC) in Hertzner
resource "hcloud_network" "main" {
  name     var.network_name
  ip_range = var.network_cidr
	
