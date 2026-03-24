# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Azure infrastructure project using Terraform for the Opella DevOps Technical Challenge. The goal is to provision Azure infrastructure with reusable, secure, and maintainable IaC.

### Key Deliverables

1. **Reusable Terraform module** for Azure Virtual Network (VNET) with flexible configuration and optional security features (e.g., NSGs, subnets)
2. **Multi-environment deployment** (dev, prod) using the VNET module plus additional resources (VM + at least one more, e.g., Blob Storage)
3. **GitHub Actions pipeline** for deployment with environment lifecycle management
4. **Clean code** with linting, formatting, and validation tooling

## Common Commands

```bash
# Initialize Terraform
terraform init

# Format all .tf files
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan for a specific environment (from the environment directory)
terraform plan -var-file=terraform.tfvars

# Apply changes
terraform apply -var-file=terraform.tfvars

# Lint with tflint (if installed)
tflint --recursive

# Generate module docs (if terraform-docs installed)
terraform-docs markdown table ./modules/vnet > ./modules/vnet/README.md
```

## Architecture Guidance

- **Module path**: Reusable VNET module should live under `modules/vnet/`
- **Environment configs**: Each environment (dev, prod) should have its own directory under `environments/` with a `terraform.tfvars` for environment-specific values
- **Naming convention**: Resources should encode environment and region in their names (e.g., `rg-opella-dev-eastus`)
- **Tagging**: All resources must have consistent tags (environment, project, region) — enforce via a common `locals` block or variable defaults
- **State**: Use Azure Storage Account backend for remote state, keyed per environment
- **Resource groups over subscriptions** for environment separation (simpler for this scope; subscriptions are better for large-scale enterprise isolation)
