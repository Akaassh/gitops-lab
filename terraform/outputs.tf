# outputs.tf
# After 'tofu apply', these values are printed — useful for scripting

output "vm_ip_addresses" {
  description = "IP addresses of all created VMs"
  value = {
    for name, vm in proxmox_virtual_environment_vm.lab_vms :
    name => split("/", tolist(vm.initialization[0].ip_config[0].ipv4)[0].address)[0]
    # This extracts just the IP (removes the /24 subnet notation)
  }
}

output "ssh_commands" {
  description = "SSH commands to connect to each VM"
  value = {
    for name, vm in proxmox_virtual_environment_vm.lab_vms :
    name => "ssh ubuntu@${split("/", tolist(vm.initialization[0].ip_config[0].ipv4)[0].address)[0]}"
  }
}