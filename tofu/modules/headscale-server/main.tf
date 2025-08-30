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

variable "server type" {
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
resource "hcloud_firewall" headscale_fw" {
  name = "headscale_fw"
  

  // SSH (22/tcp): bootstrap only; remove after Tailnet enrolment.
  rule { direction = "in"; protocol = "tcp"; port = "22";   source_ips = [var.admin_cidr]}
  

  // Headscale HTTPS API (443/tcp): public; secured by TLS + OIDC.
 rule { direction = "in"; protocol = "tcp"; port = "443";   source_ips = ["0.0.0.0/0", "::/0]}
    


























