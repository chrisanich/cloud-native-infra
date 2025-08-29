# Module: k8s-control-plane

## Purpose
This module provisions a single Kubernetes control-plane node on Hetzner Cloud.  
It is intended as the entry point for a modular, EU-compliant, cloud-native infrastructure.

## Key Features
- **OS:** Ubuntu 24.04 LTS (stable, secure, long-term supported).
- **Compliance:** Fully GDPR-safe; AI Act principles applied (least privilege, auditable).
- **Networking:** Node is attached only to the pre-defined `core-network` module.
- **Access:** SSH key-based authentication only (`ssh_key_name` must match Hetzner Console).
- **Labelling:** Node is tagged `role=control-plane` for GitOps targeting.

## Inputs
- `region`: Hetzner region (`fsn1`, `nbg1`, or `hel1`).
- `server_type`: Instance size (e.g., `cpx21`, upgradable to `cpx31` or higher).
- `ssh_key_name`: Name of SSH key registered in Hetzner Cloud Console.
- `network_id`: Network ID from the `core-network` module.

## Outputs
- `ip`: Public IPv4 address of the control-plane node, used later for kubeadm bootstrap.

## Audit & Compliance
- **GDPR:** Node resides within EU regions only.
- **AI Act:** Configuration is declarative, traceable, and minimises privileges.
- **Security:** No password login permitted; SSH key only.

## Future Extensions
- Support for multiple control-plane replicas (for HA).
- Integration with Hetzner Firewalls for stricter rule sets.
- Automated OS hardening scripts applied at boot via cloud-init.
