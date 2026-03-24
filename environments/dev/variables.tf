variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus2"
}

variable "project" {
  description = "Project name for resource naming"
  type        = string
  default     = "opella"
}

variable "primary_vnet_cidr" {
  description = "CIDR for primary VNET"
  type        = string
}

variable "secondary_vnet_cidr" {
  description = "CIDR for secondary VNET"
  type        = string
}

variable "primary_subnets" {
  description = "Subnet definitions for primary VNET"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    type             = string
  }))
}

variable "secondary_subnets" {
  description = "Subnet definitions for secondary VNET"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    type             = string
  }))
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for the AzureBastionSubnet (minimum /26)"
  type        = string
}

variable "vm_size" {
  description = "Size of the dev VM"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_zone" {
  description = "Availability zone for the VM"
  type        = string
  default     = null
}

variable "acr_name" {
  description = "Globally unique name for the container registry (alphanumeric only)"
  type        = string
}
