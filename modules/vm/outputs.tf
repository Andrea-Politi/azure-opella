output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.this.private_ip_address
  sensitive   = true
}

output "ssh_private_key_secret_id" {
  description = "Key Vault secret ID for the SSH private key"
  value       = azurerm_key_vault_secret.ssh_private_key.id
  sensitive   = true
}
