// Headscale instace using reusable Hetzner module.

module "headscale" {
  source        = "../../../../modules/hcloud-server"
  
  name		= "headscale"
  server_type	= var.server_type
  image		= var.image
  region	= var.region
  ssh_key_name	= var.ssh_key_name
  role		= "headscale"

  network_id	= var.network_id
  firewall_id   = var.firewall_id

  cloud_init    = var.cloud_init
}

// Optional: expose IP address.
output "headscale_ip" {
  value = module.headscale.ipv4
}
