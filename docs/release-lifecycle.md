# Release Lifecycle

## Pipeline Overview

This project uses a trunk-based development model with GitHub Actions for CI/CD.

## Flow

```
Feature Branch → Pull Request → Merge to main → Deploy
```

### 1. Feature Branch

Developer creates a branch and makes infrastructure changes.

### 2. Pull Request (validation gate)

Opening a PR against `main` triggers these parallel jobs:

- **Validate** (per environment matrix: dev, prod)
  - `terraform fmt -check` — enforces canonical HCL formatting
  - `terraform init` — initializes providers and modules
  - `terraform validate` — checks syntax and internal consistency
  - `terraform plan` — generates execution plan, posted as a PR comment
- **Security scan**
  - Checkov static analysis for Terraform misconfigurations (CIS benchmarks, security best practices)
- **Documentation check**
  - Verifies `terraform-docs` output is up to date in module READMEs
- **Module tests**
  - Runs `terraform test` against the VNET module (plan-only, no cloud resources needed)

Reviewers can inspect the plan output directly in the PR comment to understand exactly what will change.

### 3. Merge to main (deployment)

Merging triggers sequential deployment:

1. **Dev auto-apply** — `terraform apply` runs automatically for the dev environment
2. **Prod manual approval** — Requires approval from designated reviewers via GitHub environment protection rules, then applies

Prod deployment depends on successful dev deployment (`needs: apply-dev`), ensuring changes are validated in dev before reaching production.

### 4. Environment Protection

| Environment | Approval | Auto-deploy |
|-------------|----------|-------------|
| `dev` | None required | Yes |
| `production` | Manual approval required | After approval |

Configure environment protection rules in: GitHub repo → Settings → Environments → `production` → Required reviewers.

## Diagram

```
┌──────────┐     ┌────────────────────────────────┐     ┌───────────────────────┐
│  Branch   │────▶│  Pull Request                   │────▶│  Merge to main        │
└──────────┘     │                                │     │                       │
                 │  ├─ fmt check                  │     │  ├─ Apply dev (auto)  │
                 │  ├─ init + validate            │     │  │                     │
                 │  ├─ plan (→ PR comment)        │     │  ├─ Approval gate     │
                 │  ├─ checkov scan               │     │  │                     │
                 │  ├─ terraform-docs check       │     │  └─ Apply prod        │
                 │  └─ terraform test             │     └───────────────────────┘
                 └────────────────────────────────┘
```
