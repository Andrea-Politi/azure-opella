mock_provider "azurerm" {}

variables {
  name                = "vnet-test"
  resource_group_name = "rg-test"
  location            = "eastus2"
  address_space       = ["10.0.0.0/16"]
  enable_nat_gateway  = true
  enable_route_tables = true
  tags = {
    environment = "test"
    project     = "opella"
    managed_by  = "terraform"
  }
  subnets = [
    { name = "snet-private-1", address_prefixes = ["10.0.1.0/24"], type = "private" },
    { name = "snet-private-2", address_prefixes = ["10.0.2.0/24"], type = "private" },
    { name = "snet-public-1", address_prefixes = ["10.0.101.0/24"], type = "public" },
  ]
}

run "creates_vnet_with_correct_address_space" {
  command = plan

  assert {
    condition     = contains(azurerm_virtual_network.this.address_space, "10.0.0.0/16")
    error_message = "VNET address space does not match expected 10.0.0.0/16"
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test"
    error_message = "VNET name does not match"
  }
}

run "creates_correct_number_of_subnets" {
  command = plan

  assert {
    condition     = length(azurerm_subnet.this) == 3
    error_message = "Expected 3 subnets, got a different count"
  }
}

run "creates_public_nsg_with_correct_name" {
  command = plan

  assert {
    condition     = azurerm_network_security_group.public.name == "vnet-test-nsg-public"
    error_message = "Public NSG name does not match expected naming convention"
  }
}

run "creates_private_nsg_with_correct_name" {
  command = plan

  assert {
    condition     = azurerm_network_security_group.private.name == "vnet-test-nsg-private"
    error_message = "Private NSG name does not match expected naming convention"
  }
}

run "nat_gateway_created_when_enabled" {
  command = plan

  assert {
    condition     = length(azurerm_nat_gateway.this) == 1
    error_message = "NAT Gateway should be created when enable_nat_gateway is true"
  }

  assert {
    condition     = azurerm_nat_gateway.this[0].name == "vnet-test-natgw"
    error_message = "NAT Gateway name does not match expected naming convention"
  }
}

run "route_tables_created_when_enabled" {
  command = plan

  assert {
    condition     = length(azurerm_route_table.private) == 1
    error_message = "Private route table should be created when enable_route_tables is true"
  }

  assert {
    condition     = length(azurerm_route_table.public) == 1
    error_message = "Public route table should be created when enable_route_tables is true"
  }
}

run "nat_gateway_disabled" {
  command = plan

  variables {
    enable_nat_gateway = false
  }

  assert {
    condition     = length(azurerm_nat_gateway.this) == 0
    error_message = "NAT Gateway should not be created when disabled"
  }

  assert {
    condition     = length(azurerm_public_ip.nat) == 0
    error_message = "NAT public IP should not be created when NAT Gateway is disabled"
  }
}

run "tags_applied_to_vnet" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.tags["environment"] == "test"
    error_message = "Environment tag not applied to VNET"
  }

  assert {
    condition     = azurerm_virtual_network.this.tags["project"] == "opella"
    error_message = "Project tag not applied to VNET"
  }
}
