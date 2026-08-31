# (My) Homelab

A GitOps-driven Kubernetes (k3s) homelab, provisioned with **Nix**, **Terraform**, **Helm**, and **Argo CD**.

Argo CD watches this repo and syncs the applications defined under `charts/`, while Terraform bootstraps the cluster plugins and manages Cloudflare DNS.

## Documentation

See **[`docs/DOCUMENTATION.md`](docs/DOCUMENTATION.md)** for the full guide covering:

- Architecture overview (Terraform + Argo CD + GitOps flow)
- Getting started / prerequisites
- Terraform configuration & variables
- The `bin/dev` helper CLI
- Every Helm chart (`infrastructure`, `apps`, `ingress`, `argoapps`)
- Secrets management & External Secrets
- OS configuration (Raspberry Pi, OpenWrt routers)

### Quick status

| Area | Tooling |
|------|---------|
| Dev environment | Nix (`flake.nix`) |
| Provisioning | Terraform (`tf-*.tf`) |
| Cluster plugins | Helm via `tf-modules/k8s-helm-charts` |
| GitOps | Argo CD (`charts/infrastructure`) |
| DNS | Cloudflare (`tf-dns.tf`) |

## Repository Structure

- `bin/` – helper scripts (CLI at `bin/dev`)
- `certs/` – TLS certificates
- `charts/` – Helm charts (`apps/`, `infrastructure/`)
- `docs/` – documentation
- `os/` – OS-specific configuration
- `tf-modules/` – reusable Terraform modules
- `tf-*.tf` – Terraform configuration files

## Getting Started

This repo uses Nix + Terraform to provision a homelab infrastructure.

1. Bootstrap the environment: `nix develop`
2. Initialise Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

> Requires a k3s cluster configured as the `homelab` kubectl context, plus Cloudflare API tokens.

## Usage

- Edit `var.auto.tfvars` for environment-specific values.
- Run `./bin/` scripts to deploy services.
- Use `terraform state` commands to inspect resources.
- Argo CD auto-syncs applications from `charts/apps/*`.
