terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
  }
}

provider "hcloud" {
  # Token is read from HCLOUD_TOKEN environment variable
}

module "core_network" {
  source       = "../../../modules/core-network"
  network_name = "cloud-native-network"
  network_cidr = "10.0.0.0/16"
}
