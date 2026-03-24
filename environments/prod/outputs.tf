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
