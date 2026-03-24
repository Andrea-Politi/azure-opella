variable "name" {
  description = "Name of the VNET"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "VNET address space (e.g., [\"10.10.0.0/16\"])"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet configurations"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    type             = string # "private" or "public"
  }))

  validation {
    condition     = alltrue([for s in var.subnets : contains(["private", "public"], s.type)])
    error_message = "Subnet type must be 'private' or 'public'."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_route_tables" {
  description = "Whether to create route tables for subnets"
  type        = bool
  default     = true
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
