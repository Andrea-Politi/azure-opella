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
  description = "Tags to apply to all resources. Must include 'environment', 'project', and 'managed_by'."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "environment"),
      contains(keys(var.tags), "project"),
      contains(keys(var.tags), "managed_by"),
    ])
    error_message = "Tags must include 'environment', 'project', and 'managed_by' keys."
  }
}
