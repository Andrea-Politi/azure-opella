variable "name" {
  description = "Name of the Key Vault (globally unique, max 24 chars)"
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

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "admin_object_ids" {
  description = "List of object IDs for principals with full secret access"
  type        = list(string)
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
