# main.tf
# This file defines the actual VMs we want to create

# ─────────────────────────────────────────────────────────────
# LOCAL VALUES — computed values we use throughout this file
# ─────────────────────────────────────────────────────────────
locals {
  # Define all our VMs in one place as a map
  # This is cleaner than writing a separate resource block for each VM
  vms = {
    "vm-web-01" = {
      vm_id    = 101
      cores    = 1
      memory   = 1024        # in MB
      disk_size = "12G"
      ip       = "192.168.72.11/24"
      tags     = ["web", "nginx"]
    }
    "vm-db-01" = {
      vm_id    = 102
      cores    = 2
      memory   = 2048
      disk_size = "12G"
      ip       = "192.168.72.12/24"
      tags     = ["database", "postgres"]
    }
    "vm-mon-01" = {
      vm_id    = 103
      cores    = 2
      memory   = 2048
      disk_size = "12G"
      ip       = "192.168.72.13/24"
      tags     = ["monitoring", "prometheus"]
    }
  }
}

# ─────────────────────────────────────────────────────────────
# VM RESOURCE — creates one VM per entry in locals.vms
# ─────────────────────────────────────────────────────────────
resource "proxmox_virtual_environment_vm" "lab_vms" {
  # for_each loops over the map above, creating one resource per entry
  for_each = local.vms

  name      = each.key          # VM name (e.g., "vm-web-01")
  vm_id     = each.value.vm_id  # Proxmox VM ID
  node_name = var.proxmox_node  # Which Proxmox node to put it on
  tags      = each.value.tags

  # Clone from our template instead of installing from scratch
  clone {
    vm_id = 9000         # ID of the template we created earlier
    full  = true         # Full clone (not linked clone) for independence
  }

  # CPU configuration
  cpu {
    cores = each.value.cores
    type  = "host"  # Pass through host CPU — better performance, enables nested virt
  }

  # Memory configuration (in MB)
  memory {
    dedicated = each.value.memory
  }

  # Disk configuration
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 12
    # Discard enables TRIM on the disk — better for SSDs
    discard      = "on"
  }

  # Network configuration
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Enable the QEMU guest agent (we installed it in the template)
  agent {
    enabled = true
  }

  # Cloud-Init configuration — injected at first boot
  initialization {
    datastore_id = "local-lvm"
    # Inject our SSH public key so we can log in as 'ubuntu' user
    user_account {
      username = "ubuntu"
      keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]  # Reads your SSH public key from file
    }

    # Configure network (static IP)
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.vm_network_gateway
      }
    }

    # Set DNS servers
    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
  }

  # Wait for cloud-init to finish before OpenTofu considers VM "ready"
  lifecycle {
    ignore_changes = [
      # Ignore disk size changes on updates (Proxmox doesn't allow shrinking)
      disk,
    ]
  }
}