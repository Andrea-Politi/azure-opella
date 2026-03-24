data "azurerm_client_config" "current" {}

locals {
  common_tags = {
    environment = var.environment
    project     = var.project
    region      = var.location
    managed_by  = "terraform"
  }
  name_prefix = "${var.project}-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

module "vnet_primary" {
  source = "../../modules/vnet"

  name                = "vnet-primary-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = [var.primary_vnet_cidr]
  subnets             = var.primary_subnets
  enable_nat_gateway  = true
  enable_route_tables = true
  tags                = local.common_tags
}

module "vnet_secondary" {
  source = "../../modules/vnet"

  name                = "vnet-secondary-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = [var.secondary_vnet_cidr]
  subnets             = var.secondary_subnets
  enable_nat_gateway  = true
  enable_route_tables = true
  tags                = local.common_tags
}

# --- Key Vault ---

module "keyvault" {
  source = "../../modules/keyvault"

  name                = "kv-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  admin_object_id     = data.azurerm_client_config.current.object_id
  tags                = local.common_tags
}

# --- Bastion ---

module "bastion" {
  source = "../../modules/bastion"

  name                  = "bas-${local.name_prefix}"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  virtual_network_name  = module.vnet_primary.vnet_name
  subnet_address_prefix = var.bastion_subnet_prefix
  tags                  = local.common_tags
}

# --- Prod VM ---

module "vm" {
  source = "../../modules/vm"

  name                = "vm-prod-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.vnet_primary.subnet_ids["snet-private-1"]
  vm_size             = var.vm_size
  zone                = var.vm_zone
  key_vault_id        = module.keyvault.key_vault_id
  tags                = local.common_tags
}

# --- Container Registry ---

module "acr" {
  source = "../../modules/acr"

  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Standard"
  key_vault_id        = module.keyvault.key_vault_id
  tags                = local.common_tags
}
