terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  description = "Azure region for the state storage"
  type        = string
  default     = "eastus2"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "opella-rg-tfstate"
  location = var.location

  tags = {
    project    = "opella"
    managed_by = "terraform"
    purpose    = "terraform-state"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "stopellatfstate"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = azurerm_resource_group.tfstate.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}
