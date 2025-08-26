variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "network_name" {
  description = "Name of the Hetzner network (VPC)"
  type        = string
  default     = "cloud-native-network"
}

variable "network_cidr" {
  description = "CIDR block for the network"
  type        = string
  default     = "10.0.0.0/16"
}
