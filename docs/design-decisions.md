# Design Decisions

## Resource Groups vs. Subscriptions for Environment Separation

We use **Resource Groups** (one per environment per region) rather than separate Azure Subscriptions.

### Why Resource Groups

- **Simplicity** — Single subscription, single set of credentials, single billing view
- **Appropriate for scope** — This project has dev/prod environments; separate subscriptions add overhead with no benefit at this scale
- **Faster iteration** — No cross-subscription IAM, networking, or billing configuration
- **Sufficient isolation** — RG-level RBAC, separate Terraform state files, directory-based Terraform isolation, and naming conventions provide adequate separation

### When to use Subscriptions instead

- Enterprise-scale with strict blast-radius requirements
- Regulatory environments requiring hard billing or quota separation
- When teams need fully independent subscription-level policies
- Azure Landing Zone architecture (hub-spoke with subscription-per-workload)

### Our approach

- Each environment gets its own RG: `rg-opella-dev-eastus2`, `rg-opella-prod-eastus2`
- Separate Terraform state files per environment (different blob keys in the same storage account)
- Directory-based isolation (`environments/dev/`, `environments/prod/`) prevents accidental cross-environment operations

## Tag Enforcement

All modules enforce required tags (`environment`, `project`, `managed_by`) via Terraform variable validation.

### Why Terraform validation over Azure Policy

- **Earlier feedback** — Catches violations at `terraform plan` time, before any resources are created
- **No additional Azure resources** — No policy definitions or assignments to manage
- **Simpler** — A single `validation` block in each module's `tags` variable
- **Portable** — Works regardless of Azure subscription permissions

### How it works

```hcl
variable "tags" {
  type = map(string)
  validation {
    condition = alltrue([
      contains(keys(var.tags), "environment"),
      contains(keys(var.tags), "project"),
      contains(keys(var.tags), "managed_by"),
    ])
    error_message = "Tags must include 'environment', 'project', and 'managed_by' keys."
  }
}
```

If a caller omits any required tag, `terraform plan` fails immediately with a clear error message.

## Azure Bastion over Traditional Jump Box

We use Azure Bastion instead of a VM with port 22 exposed to the internet.

### Why

- **No public IPs on VMs** — VMs stay in private subnets with no internet-facing surface
- **No port 22 exposure** — Bastion proxies SSH over HTTPS (port 443) through the Azure control plane
- **Managed service** — Azure handles patching, scaling, and availability
- **Audit trail** — All sessions are logged through Azure diagnostics

### Trade-off

Azure Bastion costs ~$140/month. For production this is justified. For dev, consider disabling it when not in use.
