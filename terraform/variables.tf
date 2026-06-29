# variables.tf
# Variables make our code reusable and keep secrets out of the code itself

variable "proxmox_url" {
  #description = "https://192.168.72.128:8006/api2/json"
  description = "https://192.168.72.128:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "root@akash!opentofu=46549ea7-4899-418f-9826-1dd3893a86d9"
  type        = string
  sensitive   = true  # OpenTofu will never print this value in logs
}

variable "proxmox_node" {
  description = "SKYNET"
  type        = string
  default     = "pve"
}

variable "ssh_public_key" {
  description = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALK7gO1M7XIcSlqDN0InM5IRgKaNFhWGwy9AM8WdOsGnwAAAKDdO9ss3TvbLAAAAAtzc2gtZWQyNTUxOQAAACCh7gO1M7XIcSlqDN0InM5IRgKaNFhWGwy9AM8WdOsGnwAAAEChc3d3oSKHYEhdjGOZ8of6NHs65YSCdOfgypufELJyx6HuA7UztchxKWoM3QiczkhGApo0WFYbDL0AzxZ06wafAAAAGWFlc3RoZXRpY3NvdWw4NEBnbWFpbC5jb20BAgME"
  type        = string
  default     = ""
}

variable "vm_network_gateway" {
  description = "Default gateway for VMs (your router IP)"
  type        = string
  default     = "192.168.72.2"
}