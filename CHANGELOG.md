# Changelog

All notable activities and decisions for this project are documented here.

## 2026-03-24

### Bootstrap — Remote State Storage
- Created `bootstrap/` directory with local-state Terraform config
- Provisioned `opella-rg-tfstate` resource group in `eastus`
- Provisioned `stopellatfstate` storage account (Standard LRS, TLS 1.2, blob versioning)
- Provisioned `tfstate` private blob container
- Applied successfully: 3 resources created

### Project Structure
- Created directory layout: `environments/{dev,prod}`, `modules/vnet`, `.github/workflows`
- Added `.gitignore` covering `*.tfvars`, `.terraform/`, `*.tfstate`
- Configured `azurerm` provider (~> 4.0) with env-var-based auth (least privilege)
- Remote backend per environment: `dev/terraform.tfstate`, `prod/terraform.tfstate`

### VNET Module (`modules/vnet`)
- Reusable module accepting CIDR, subnet definitions (private/public type), toggles for NAT Gateway and route tables
- Resources: VNET, subnets (for_each), NAT Gateway + public IP (conditional), route tables with subnet associations
- Network Security Groups:
  - **Public NSG**: Allow TCP 80, 443 from `0.0.0.0/0`, deny all other inbound
  - **Private NSG**: Allow all from `VirtualNetwork`, deny all other inbound
- NSGs auto-associated to subnets by type

### Dev Environment Deployment
- Resource group: `rg-opella-dev-eastus`
- Primary VNET (`10.10.0.0/16`): 3 private subnets (`10.10.1-3.0/24`), 3 public subnets (`10.10.101-103.0/24`)
- Secondary VNET (`10.255.0.0/16`): 3 private subnets (`10.255.1-3.0/24`)
- NAT Gateway per VNET with static public IP
- Route tables (private: BGP propagation disabled, public: separate)
- Applied successfully: 50 resources created

### Design Decisions
- **Directory-based isolation** over Terraform workspaces — each environment has own backend config, preventing accidental cross-env operations
- **Resource groups over subscriptions** for environment separation (appropriate for project scope)
- **Sensitive outputs** — all resource IDs and IPs marked `sensitive = true`
- **Naming convention**: `{type}-{purpose}-{project}-{env}-{region}` (e.g., `vnet-primary-opella-dev-eastus`)
- **Tagging**: environment, project, region, managed_by on all resources

### Region Migration
- Destroyed all `eastus` resources due to VM SKU capacity restrictions on free-tier subscription
- Redeployed entire dev environment to `eastus2`
- Bootstrap state storage remains in `eastus` (state backend is region-independent)

### Additional Modules
- **Key Vault** (`modules/keyvault`): Standard SKU, access-policy-based auth, Purge+Recover permissions for lifecycle management
- **Bastion** (`modules/bastion`): Azure Bastion (managed SSH/RDP proxy), dedicated `AzureBastionSubnet`, dedicated NSG with Azure-required rules (443, GatewayManager, 8080/5701 data plane), Basic SKU
- **VM** (`modules/vm`): Linux VM with TLS-generated SSH key pair, private key auto-stored in Key Vault, configurable size/zone/image, no public IP (access via Bastion only)
- **ACR** (`modules/acr`): Azure Container Registry (Azure's ECR equivalent), admin credentials auto-stored in Key Vault, configurable SKU
- All 4 modules are reusable across environments

### Dev Environment — Additional Resources (eastus2)
- Key Vault: `kv-opella-dev-eastus2` with service principal access policy
- Bastion: `bas-opella-dev-eastus2` in `10.10.200.0/26` subnet of primary VNET
- ACR: `acropelladev` (Basic tier)
- VM: **blocked** — Azure free-tier subscription has capacity restrictions on all VM SKUs across all tested regions (eastus, eastus2, westus2, northeurope). Support request needed.
- Applied: 62/63 resources created

### Design Decisions (continued)
- **Azure Bastion over jump box** — eliminates port 22 exposure to internet, managed service with HTTPS-only access
- **Key Vault for secrets** — SSH keys and ACR credentials stored centrally, not in state or tfvars
- **data.azurerm_client_config** — dynamically resolves tenant/object IDs instead of hardcoding in tfvars

### GitHub Actions Pipeline (`.github/workflows/terraform.yml`)
- **Validate job** (PR): `fmt -check`, `init`, `validate`, `plan` per environment (matrix strategy)
- **Plan comment**: auto-posts plan output as PR comment for reviewers
- **Security scan** (PR): Checkov static analysis for Terraform misconfigurations
- **Apply dev** (merge to main): auto-applies dev environment
- **Apply prod** (merge to main): requires manual approval via GitHub `production` environment protection rules
- Prod deploy depends on successful dev deploy (sequential gating)

### Next Steps
- Configure GitHub environment protection rules for `production`
- Set GitHub secrets: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`
- Resolve VM capacity restriction (Azure support request)
- Prod environment tfvars configuration
