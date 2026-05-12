# AGENTS.md — DigiProc Terraform Modules

## Project Overview

Reusable Terraform modules shared across DigiProc infrastructure stacks. Consumed via git source refs pinned to specific SHAs from `digiproc-infrastructure` and other Terraform configurations. Terraform 1.3+, AWS provider ~> 4.45. Branch: `master` (not `main`).

## Module catalog

Each top-level directory is a self-contained module:

| Module | Purpose |
|---|---|
| `cloudfront/` | CloudFront distributions (SPA, redirect, custom) |
| `cloudwatch/` | CloudWatch log groups, alarms |
| `ecs/` | ECS clusters, services, task definitions |
| `elasticache/` | ElastiCache Redis clusters |
| `iam/` | IAM roles, policies, instance profiles |
| `lambda/` | Lambda functions + Lambda@Edge |
| `rds/` | RDS instances + parameter groups |
| `redirect/` | CloudFront-based redirect distributions |
| `ses/` | SES configurations |
| `spa/` | Static site (S3 + CloudFront) |
| `ssl/` | ACM certificates (us-east-1 for CloudFront) |
| `zip/` | Helper for zipping Lambda deployment artifacts |

`terraform/` and `tools/` hold shared helpers (locals, scripts).

## Conventions

- **Module sources**: callers pin to a specific git SHA via `source = "git::ssh://git@github.com/.../terraform-modules.git//<module>?ref=<sha>"`. Never reference `master`, `main`, or `latest` from consumer code.
- **Variables**: every module declares `variable` blocks with descriptions and types in `variables.tf`. Sensitive inputs use `sensitive = true`.
- **Outputs**: every module exposes useful resource attributes in `outputs.tf` so consumers can reference them.
- **Naming**: resource names use `var.name` interpolation (e.g., `"${var.name}-bucket"`). Locals for repeated patterns.
- **Tags**: every taggable resource accepts a `var.tags` map and applies it (merged with module-level defaults if any).
- **Region**: do not hardcode `eu-west-1`. Resources requiring a non-default region (e.g., ACM for CloudFront in `us-east-1`) accept a provider alias parameter.

## Adding or modifying a module

1. Create a feature branch off `master`
2. Modify the module in its directory
3. Run `terraform fmt -recursive` on edited files
4. Verify backward compatibility — if you break a variable name or output, communicate the breaking change in the PR description so consumers know to coordinate the upgrade
5. After merge to `master`, capture the new SHA and update consumers (`digiproc-infrastructure`) to pin to it

## Never do

- Never reference modules without a pinned SHA — `?ref=master` and `?ref=HEAD` are forbidden in consumer code
- Never modify a module in a way that silently changes existing resources for consumers pinned to an older SHA (state diffs must be intentional and communicated)
- Never commit `.tfstate` or `.tfvars` containing secrets
- Never apply terraform here — this repo only defines modules, it doesn't manage state

## PR Process

- Branch: `feature/deli-{ticket}-{description}` (matches the platform convention)
- Commit messages: `DELI-{ticket}: …` or conventional (`feat:`, `fix:`, `chore:`)
- CI: `terraform fmt -check -diff` + `terraform validate` on every module
