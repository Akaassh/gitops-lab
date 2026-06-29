# providers.tf
# This tells OpenTofu which providers we need and where to download them from

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
}

# Configure the Proxmox provider — how to connect to our Proxmox host
provider "proxmox" {
  endpoint  = var.proxmox_url       # e.g., "https://192.168.72.128:8006/"
  api_token = var.proxmox_api_token # e.g., "root@pam!opentofu=xxxxxxxx-..."
  insecure  = true                  # Skip TLS verification for self-signed cert (fine for homelab)

  ssh {
    agent    = false
    username = "root"
    # OpenTofu sometimes needs SSH access to Proxmox for certain operations
    # We'll use the same SSH key you use to log into Proxmox
  }
}