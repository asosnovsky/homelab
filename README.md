# (My) Homelab

## Repository Structure

- `bin/` – helper scripts
- `certs/` – TLS certificates
- `charts/` – Helm charts
- `os/` – OS‑specific configuration
- `tf-modules/` – reusable Terraform modules
- `tf-*.tf` – Terraform configuration files

## Getting Started

This repo uses Nix + Terraform to provision a homelab infrastructure.

1. Bootstrap the environment: `nix develop`
2. Initialise Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

## Usage

- Edit `var.auto.tfvars` for environment‑specific values.
- Run `./bin/` scripts to deploy services.
- Use `terraform state` commands to inspect resources.
