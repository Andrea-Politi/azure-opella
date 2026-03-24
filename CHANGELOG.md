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

### Automated Documentation (`terraform-docs`)
- Added `.terraform-docs.yml` root config (markdown table, inject mode)
- Auto-generated README.md for all 5 modules (vnet, bastion, vm, acr, keyvault)
- CI job (`Check terraform-docs`) fails PR if docs are stale
- Docs include: providers, resources, inputs (sorted by required), outputs

### Module Tests (`terraform test`)
- 8 plan-only tests for the VNET module using `mock_provider` (no Azure credentials needed)
- Tests cover: VNET creation, subnet count, NSG naming, NAT Gateway toggle, route tables, tag propagation
- CI job (`Module tests`) runs on every PR

### Tag Enforcement
- All 5 modules enforce required tags (`environment`, `project`, `managed_by`) via `validation` blocks
- Fails at `terraform plan` time with a clear error message
- Chosen over Azure Policy for simplicity and earlier feedback

### Key Vault — Multi-Principal Access
- Changed `admin_object_id` (string) to `admin_object_ids` (list) with `dynamic` access_policy block
- Supports both local CLI identity and CI service principal accessing the same Key Vault
- Manually added CI service principal to existing Key Vault to resolve chicken-and-egg bootstrap issue

### CI Pipeline — Final Configuration
- **6 stages**: validate (matrix), module tests, terraform-docs check, security scan, apply dev, apply prod
- CI copies `terraform.tfvars.example` → `terraform.tfvars` (no secrets in tfvars files)
- GitHub repository secrets configured: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`
- All checks passing on PR

### Documentation
- `docs/design-decisions.md`: RG vs subscriptions argument, tag enforcement rationale, Bastion vs jump box
- `docs/release-lifecycle.md`: full pipeline flow with diagram (PR → validate → merge → apply dev → approval → apply prod)
- `docs/tooling.md`: all tools (fmt, validate, test, checkov, terraform-docs, tflint), local dev commands
- `docs/plan-outputs/`: bootstrap and full dev plan outputs (63 resources) as required by challenge

### Known Issues
- **VM creation blocked** — Azure free-tier subscription has capacity restrictions on all VM SKUs across all tested regions. Terraform code is correct; requires Azure support request to lift restriction.
