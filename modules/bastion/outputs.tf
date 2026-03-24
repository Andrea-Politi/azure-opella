output "bastion_id" {
  description = "ID of the Bastion host"
  value       = azurerm_bastion_host.this.id
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = azurerm_public_ip.bastion.ip_address
  sensitive   = true
}

output "bastion_subnet_id" {
  description = "ID of the AzureBastionSubnet"
  value       = azurerm_subnet.bastion.id
}
