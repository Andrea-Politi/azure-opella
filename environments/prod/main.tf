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
