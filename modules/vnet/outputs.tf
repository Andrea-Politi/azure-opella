output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet name to subnet ID"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (null if disabled)"
  value       = var.enable_nat_gateway ? azurerm_nat_gateway.this[0].id : null
}

output "nat_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = var.enable_nat_gateway ? azurerm_public_ip.nat[0].ip_address : null
  sensitive   = true
}

output "private_route_table_id" {
  description = "ID of the private route table (null if disabled)"
  value       = var.enable_route_tables ? azurerm_route_table.private[0].id : null
}

output "public_route_table_id" {
  description = "ID of the public route table (null if disabled)"
  value       = var.enable_route_tables ? azurerm_route_table.public[0].id : null
}

output "public_nsg_id" {
  description = "ID of the public subnet NSG"
  value       = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  description = "ID of the private subnet NSG"
  value       = azurerm_network_security_group.private.id
}
