# ACR Module

Provisions an Azure Container Registry (Azure's ECR equivalent) with admin credentials stored in Key Vault.

## Features

- Configurable SKU tier (Basic/Standard/Premium)
- Optional admin user with credentials auto-stored in Key Vault
- Conditional secret creation (only when admin is enabled)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_key_vault_secret.acr_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.acr_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the Key Vault to store admin credentials | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the container registry (globally unique, alphanumeric only) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. Must include 'environment', 'project', and 'managed\_by'. | `map(string)` | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Whether admin user is enabled | `bool` | `true` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU tier (Basic, Standard, Premium) | `string` | `"Basic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | ID of the container registry |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | Login server URL of the container registry |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | Name of the container registry |
<!-- END_TF_DOCS -->
