// File: tofu/modules/hcloud-firewall/main.tf
// Purpose: Baseline firewall for Kubernetes nodes on Hetzner Cloud.

variable "name" {
  type         = string
  description  = "Firewall name"
  default      = "k8s-firewall"
}

variable "admin_cidr" {
  type         = string
  description  = "Admin CIDR allowed for SSH (e.g., 203.0.113.5/32)"
}

variable "cluster_cidr" {
  type         = string
  description  = "Private network CIDR for infra-cluster traffic (e.g., 10.0.0.0/16)"
}

resource "hcloud_firewall" "this" {
  name         = var.name


  // --- Inbound: admin access.
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.admin_cidr]
  }


  // --- Inbound: Kubernetes control-plane and kubelet (intra-VPC only).
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"		    // kube-apiserver.
    source_ips = [var.cluster_cidr]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "10250"	    // kubelet API.
    source_ips = [var.cluster_cidr]
  }


  // --- Inbound: Cilium overlays (choose what is used; safe to allow both).
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "8472"		   // VXLAN (Cilium overlay).
    source_ips = [var.cluster_cidr]  
  }
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "51871"           // WireGuard (Cilium encryption default).
    source_ips = [var.cluster_cidr]
  }

  
  // --- Inbound: NodePort range for cloud Load Balancer to reach nodes (private only). 
  rule {
    direction       = "in"
    protocol        = "tcp"
    port            = "30000-32767"
    source_ips      = [var.cluster_cidr]
  }
  rule {
    direction       = "in"
    protocol        = "udp"
    port            = "30000-32767"
    source_ips          = [var.cluster_cidr]
  }


  // --- Egress: allow updates, image pulls, DNS, ICMP, etc.
  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = "any"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction       = "out"
    protocol        = "udp"
    port            = "any"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction       = "out"
    protocol        = "icmp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}

output "firewall_id" {
  value       = hcloud_firewall.this.id
  description = "Firewall ID to attach to servers"
}
