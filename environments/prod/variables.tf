variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
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
