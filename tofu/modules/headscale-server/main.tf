// Module: headscale-server
// Purpose: Provision a dedicated Headscale control server in Hetzner (EU).
// Compliance: EU region by default (fsn1). Ingress is least-privilege.
// Post-bootstrap: remove SSH and rely on Tailnet identities (Zero Trust).

// ---------- Inputs ----------
variable "region" {
  type        = string
  description = "Hetzner region (fsn1, nbg1, hel1)"
  default     = "fsn1"  // Keep control-plane in EU jurisdiction.
}

variable "server_type" {
  type		= string
  description	= "Hetzner server type (e.g., cx22, cax11)"
  default	= "cx22"  // Headscale is lightweight; 2vCPU/4GB is ample.
}

variable "ssh_key_name" {
  type		= string
  description   = "SSH key name registered in Hetzner (bootstrap only)"
}

variable "admin_cidr" {
  type		= string
  description	= "Temporary SSH source (e.g., 194.156.225.60/32). Replace with Tailnet later."
}

// ---------- Firewall (ingress minimal, egress open for updates/DNS) ---------- 
resource "hcloud_firewall" "headscale_fw" {
  name = "headscale-fw"
  

  // SSH (22/tcp): bootstrap only; remove after Tailnet enrolment.
  rule { direction = "in"; protocol = "tcp"; port = "22";    source_ips = [var.admin_cidr] }
  

  // Headscale HTTPS API (443/tcp): public; secured by TLS + OIDC.
  rule { direction = "in"; protocol = "tcp"; port = "443";   source_ips = ["0.0.0.0/0", "::/0"] }
  

  // STUN (3478/udp): NAT traversal for WireGuard peers.
  rule { direction = "in"; protocol = "udp"; port = "3478";  source_ips = ["0.0.0.0/0", "::/0"] }
  
  // Egress for package updates, ACME, DNS, telemetry (no restrictions).
  rule { direction = "out"; protocol = "tcp";  port = "any"; destination_ips = ["0.0.0.0/0", "::/0"] }
  rule { direction = "out"; protocol = "udp";  port = "any"; destination_ips = ["0.0.0.0/0", "::/0"] }
  rule { direction = "out"; protocol = "icmp"; port = "any"; destination_ips = ["0.0.0.0/0", "::/0"] }
}

// ---------- Server ----------
resource "hcloud_server" "headscale" {
  name        = "headscale"
  server_type = var.server_type
  image       = "ubuntu-24.04"
  location    = var.region
  ssh_keys    = [var.ssh_key_name]

 
  // Attach firewall at birth to ensure secure-by-default posture.
  firewall_ids = [hcloud_firewall.headscale_fw.id]
  
  labels = {
    role = "headscale"
    gdpr = "eu-only"
  }
}

// ---------- Outputs ----------
output "ip" {
  value		= hcloud_server.headscale.ipv4_address
  description   = "Public IPv4 for DNS (A record -> headscale.anichlabs.com)"
}

output "firewall_id" {
  value		= hcloud_firewall.headscale_fw.id
  description	= "Firewall protecting the Headscale control server"
}

