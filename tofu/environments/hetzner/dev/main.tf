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

module "k8s_control_plane" {
  source      = "../../modules/k8s-control-plane"
  region      = "fsn1"
  server_type = "cpx21"
  ssh_key_name = "tuxedo-ed25519"
}

module "k8s_nodes" {
  source      = "../../modules/k8s-node"
  region      = "fsn1"
  server_type = "cpx21"
  ssh_key_name = "tuxedo-ed25519"
  count       = 2
}

output "control_plane_ip" {
  value = module.k8s_control_plane.ip
}

output "worker_ips" {
  value = module.k8s_nodes.ips
}  
