variable "name" {
  description = "Name prefix for bastion resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the VNET to create the AzureBastionSubnet in"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for AzureBastionSubnet (minimum /26)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
