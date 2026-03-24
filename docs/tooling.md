# Tooling & Code Quality

## Tools

| Tool | Purpose | When it runs |
|------|---------|-------------|
| `terraform fmt` | Enforces canonical HCL formatting | CI (PR) + local |
| `terraform validate` | Checks syntax and internal consistency | CI (PR) + local |
| `terraform test` | Native test framework for modules | CI (PR) + local |
| `checkov` | Security/compliance static analysis | CI (PR) |
| `terraform-docs` | Auto-generates module documentation from code | CI (PR) + local |
| `tflint` | Terraform linter with provider-aware rules | Local (recommended) |

## Local Development

```bash
# Format all files
terraform fmt -recursive

# Validate (from an environment directory)
cd environments/dev
terraform init
terraform validate

# Lint (requires tflint installed)
tflint --recursive

# Generate module documentation
terraform-docs -c .terraform-docs.yml modules/vnet

# Run module tests
cd modules/vnet
terraform init -backend=false
terraform test
```

## CI Pipeline

All tools except `tflint` run automatically on pull requests. See [release-lifecycle.md](release-lifecycle.md) for the full pipeline flow.

## Automated Documentation

Module READMEs are auto-generated using [terraform-docs](https://terraform-docs.io/). Each module README contains:

- Feature description (hand-written, above the markers)
- Requirements, providers, resources, inputs, outputs (auto-generated between `<!-- BEGIN_TF_DOCS -->` / `<!-- END_TF_DOCS -->` markers)

To regenerate after changing a module's interface:

```bash
terraform-docs -c .terraform-docs.yml modules/<module-name>
```

The CI pipeline checks that docs are up to date on every PR. If they're stale, the PR will fail.
