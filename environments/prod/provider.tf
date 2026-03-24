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

  # Auth via environment variables (ARM_CLIENT_ID, ARM_CLIENT_SECRET,
  # ARM_TENANT_ID, ARM_SUBSCRIPTION_ID). Never hardcode credentials.
}
