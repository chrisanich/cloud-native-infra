module "core_network" {
  source       = "../../../modules/core-network"
  hcloud_token = var.hcloud_token

  network_name = "cloud-native-network"
  network_cidr = "10.0.0.0/16"
}
