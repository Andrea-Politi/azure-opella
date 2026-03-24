resource "azurerm_key_vault" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false
  purge_protection_enabled   = false

  dynamic "access_policy" {
    for_each = var.admin_object_ids
    content {
      tenant_id = var.tenant_id
      object_id = access_policy.value

      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Purge",
        "Recover",
      ]
    }
  }

  tags = var.tags
}
