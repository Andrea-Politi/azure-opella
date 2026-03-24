variable "name" {
  description = "Name of the container registry (globally unique, alphanumeric only)"
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

variable "sku" {
  description = "SKU tier (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Whether admin user is enabled"
  type        = bool
  default     = true
}

variable "key_vault_id" {
  description = "ID of the Key Vault to store admin credentials"
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
