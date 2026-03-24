terraform {
  backend "azurerm" {
    resource_group_name  = "opella-rg-tfstate"
    storage_account_name = "stopellatfstate"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}
