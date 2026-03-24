resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags
}

resource "azurerm_key_vault_secret" "acr_admin_username" {
  count = var.admin_enabled ? 1 : 0

  name         = "${var.name}-admin-username"
  value        = azurerm_container_registry.this.admin_username
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "acr_admin_password" {
  count = var.admin_enabled ? 1 : 0

  name         = "${var.name}-admin-password"
  value        = azurerm_container_registry.this.admin_password
  key_vault_id = var.key_vault_id
}
