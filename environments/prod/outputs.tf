output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "primary_vnet_id" {
  description = "ID of the primary VNET"
  value       = module.vnet_primary.vnet_id
  sensitive   = true
}

output "primary_subnet_ids" {
  description = "Map of subnet name to ID for the primary VNET"
  value       = module.vnet_primary.subnet_ids
  sensitive   = true
}

output "secondary_vnet_id" {
  description = "ID of the secondary VNET"
  value       = module.vnet_secondary.vnet_id
  sensitive   = true
}

output "secondary_subnet_ids" {
  description = "Map of subnet name to ID for the secondary VNET"
  value       = module.vnet_secondary.subnet_ids
  sensitive   = true
}

output "keyvault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.key_vault_name
}

output "keyvault_uri" {
  description = "URI of the Key Vault"
  value       = module.keyvault.key_vault_uri
  sensitive   = true
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = module.bastion.bastion_public_ip
  sensitive   = true
}

output "vm_private_ip" {
  description = "Private IP of the prod VM"
  value       = module.vm.vm_private_ip
  sensitive   = true
}

output "acr_login_server" {
  description = "Login server URL for the container registry"
  value       = module.acr.acr_login_server
  sensitive   = true
}
