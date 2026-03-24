# VM Module

Provisions a Linux Virtual Machine with auto-generated SSH key pair stored in Key Vault.

## Features

- RSA 4096-bit SSH key pair generated via TLS provider
- Private key automatically stored in Key Vault
- NIC with dynamic private IP (no public IP — access via Bastion)
- Configurable VM size, availability zone, and source image
- Password authentication disabled (SSH-only)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.ssh_private_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the Key Vault to store the SSH private key | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual machine | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet to place the VM in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. Must include 'environment', 'project', and 'managed\_by'. | `map(string)` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username for the VM | `string` | `"azureuser"` | no |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | Source image reference | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = string<br/>  })</pre> | <pre>{<br/>  "offer": "0001-com-ubuntu-server-jammy",<br/>  "publisher": "Canonical",<br/>  "sku": "22_04-lts-gen2",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Azure VM size | `string` | `"Standard_B1s"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Availability zone for the VM (null for no zone) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssh_private_key_secret_id"></a> [ssh\_private\_key\_secret\_id](#output\_ssh\_private\_key\_secret\_id) | Key Vault secret ID for the SSH private key |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | ID of the virtual machine |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the virtual machine |
| <a name="output_vm_private_ip"></a> [vm\_private\_ip](#output\_vm\_private\_ip) | Private IP address of the VM |
<!-- END_TF_DOCS -->
