# HomeLab

> GitOps-driven Kubernetes (k3s) homelab infrastructure, provisioned with **Nix**, **Terraform**, **Helm**, and **Argo CD**.

This repository provisions and manages the author's home cluster. It is built around three layers:

1. **Bootstrap** – a Nix dev shell provides all tooling (`terraform`, `helm`, `kubectl`, `k3d`, `argocd`, etc.).
2. **Provisioning** – Terraform installs the cluster "plugins" (Argo CD, MetalLB, cert-manager, Traefik, External Secrets, Tailscale operator) directly on the cluster and configures DNS on Cloudflare.
3. **GitOps** – Argo CD watches this repo and syncs the applications in `charts/apps/*` and `charts/infrastructure/*`.

---

## Repository Structure

```
.
├── bin/                      # Helper CLI scripts (dev)
│   └── extra/common.sh       # Shared helpers + CLI dispatch
├── certs/                    # TLS certificates (currently empty)
├── charts/                   # Helm charts
│   ├── apps/                 # Application charts (deployed via Argo CD ApplicationSet)
│   │   ├── argoapps/         # Extra Argo applications (compose apps, NFS storage)
│   │   ├── authelia/         # Authentication / SSO
│   │   ├── certs/            # Certificate management (cert-manager issuers)
│   │   ├── dummy/            # Example/demo chart
│   │   ├── ingress/          # Reverse proxies, services & ingress rules
│   │   └── torrents/         # Torrenting stack
│   └── infrastructure/       # Cluster-level manifests (Argo CD, MetalLB, secrets)
├── os/                       # OS-specific configuration
│   ├── raspberrypi2-raspbian # ARM device config (compose) that can't run Nix
│   └── routers/              # OpenWrt router config (mesh & themes)
├── tf-modules/               # Reusable Terraform modules
│   └── k8s-helm-charts/      # Generic Helm release install module
├── tf-*.tf                   # Terraform root configuration
├── flake.nix                 # Nix dev shell definition
├── flake.lock                # Pinned Nix inputs
└── var.auto.tfvars           # Environment-specific variables (gitignored pattern)
```

---

## Getting Started

The environment is set up via Nix and provisioned with Terraform.

### Prerequisites

- [nix](https://nixos.org/) with flakes enabled
- A k3s cluster, configured as the `homelab` kubectl context
- Cloudflare account + API tokens (for DNS & cert-manager DNS-01)

### Setup

```sh
# 1. Enter the Nix dev shell (sets up all tooling + PATH)
nix develop

# 2. Provide secrets and environment values
#    Edit var.auto.tfvars (Cloudflare tokens, Gitea, Tailscale, VPN, globals...)

# 3. Initialise Terraform and apply
terraform init
terraform plan
terraform apply
```

> **Note:** `var.auto.tfvars` is matched by `*.tfvars*` in `.gitignore`, so the checked-in file won't be committed by default. Be careful — secrets should be kept out of version control.

---

## Architecture Overview

### Key flows

- **DNS:** Terraform looks up your current IP (`https://api.myip.com/`) and creates `A` records on Cloudflare for every zone/record in `domain_mappings` (unless an IP is pinned).
- **Plugins:** Terraform uses the `k8s-helm-charts` module to install `external-secrets`, `metallb`, `cert-manager`, `argo-cd`, `tailscale-operator`, and `traefik`. Each lands in its own `plugin-<name>` namespace.
- **Infrastructure:** Terraform deploys `charts/infrastructure`, which creates the Argo CD repo credentials, `AppProject main`, the ApplicationSet that watches `charts/apps/*`, the MetalLB IP address pool, and External Secrets ClusterSecretStores.
- **GitOps:** The ApplicationSet automatically creates an Argo CD Application for each folder under `charts/apps/`, syncing it to its own namespace. Value files `values.yaml` + `values-<deployment>.yaml` are merged per deployment environment.
- **Load balancer:** Argo CD server is exposed on `10.0.100.2` (MetalLB pool) via the `kubernetes_service_v1.argocd-metallb` resource.

---

## Terraform

### Providers

| Provider | Version | Purpose |
|----------|---------|---------|
| `hashicorp/helm` | `3.0.0-pre1` | Install Helm charts directly |
| `hashicorp/kubernetes` | `2.35.1` | Create namespaces, secrets, services |
| `hashicorp/http` | `3.4.5` | Discover public IP |
| `cloudflare/cloudflare` | `5.2.0` | Manage DNS records |
| `hashicorp/random` | `3.7.2` | Random values |

The Terraform **state backend** is stored in a Kubernetes secret (`secret_suffix = "homelab"` in the `default` namespace) on the `homelab` context.

### Key configuration files

| File | Purpose |
|------|---------|
| `tf-provider.tf` | Backend + provider configuration |
| `tf-variables.tf` | All input variables (see below) |
| `tf-dns.tf` | Cloudflare DNS records + public IP lookup |
| `tf-modules.tf` | Plugin Helm releases + `infrastructure` chart |
| `tf-ns-ingress.tf` | Argo CD server LoadBalancer service |
| `tf-secrets.tf` | VPN credentials secret in `secrets` namespace |
| `tf-svc.tf` | Service-related declarations |
| `var.auto.tfvars` | Environment values (DNS maps, globals, secrets) |

### Input variables

| Variable | Type | Description |
|----------|------|-------------|
| `myip` | `string` | Pin your public IP (default: auto-detected) |
| `cloudflare` | `object` (sensitive) | Cloudflare `api_token`, `account_id`, `cm_api_token` |
| `main_domain` / `secondary_domain` | `string` | Defaults `sosnovsky.ca` / `skyg.ca` |
| `domain_mappings` | `map(map(...))` | DNS zone → records → type/IP |
| `gitea` | `object` (sensitive) | GitOps repo username/password |
| `github_ssh_key` | `string` (sensitive) | SSH key for the helm-charts git repo |
| `tailscale` | `object` (sensitive) | Tailscale OAuth client id/secret |
| `vpn` | `object` (sensitive) | VPN user/password/provider/country |
| `globals` | `object` | Global app config (DNS, NFS, SMTP, deployment, email, timezone) |

---

## `bin/dev` CLI

The `bin/dev` script is a small self-documenting CLI built on `common.sh`. Each subcommand matches a `run-<name>` function; running `bin/dev` with no args lists them with their doc comments.

| Command | Description |
|---------|-------------|
| `dev new-chart <path>` | Scaffold a new Helm chart under `charts/apps/` (Chart.yaml + values.yaml + templates/) |
| `dev upload-tfvars` | Push `var.auto.tfvars` into a `tfvars` secret in the `default` namespace |
| `dev download-tfvars` | Pull the `tfvars` secret back into `var.auto.tfvars` |
| `dev template <app>` | Render a deployed Argo app's Helm output locally (reads its spec from Argo CD) |
| `dev template-compose-app <name>` | Render a compose-app chart under `charts/apps/argoapps/compose-apps/` |
| `dev htpasswd [...]` | Generate an Apache-style htpasswd hash (`openssl passwd -apr1`) |

---

## Helm Charts

### `charts/infrastructure`

Cluster-scoped bootstrap resources. Version `0.1.15`. Rendered values come from `tf-modules.tf` (`repos.*`, `gitops.*`, `ns.*`, `global`).

Templates:

| Template | Contents |
|----------|----------|
| `argocd-appset.yml` | ApplicationSet that watches `charts/apps/*` in the gitops repo |
| `argocd-projects.yaml` | `main` AppProject (cluster/destination/source allow-all) |
| `argocd-repo-gitops.yaml` | Repository secret for the homelab gitops repo |
| `argocd-repo-additionals.yaml` | Additional repo secrets (e.g. GitHub `helm-charts`) |
| `es-cluster-store.yaml` | External Secrets ClusterSecretStore + RBAC per namespace |
| `ips.yml` | MetalLB `IPAddressPool` + `L2Advertisement` |

Key default `values.yaml`:

```yaml
registry:
  ip: 10.0.100.101
ns:
  metallb: "change-me"
  argocd: "change-me"
gitops:
  url: http://minipc1.lab.internal:3000/ari/homelab.git
  revision: main
  data: { username: argocd, password: "change-me" }
repos:
  github-helm-charts:
    url: git@github.com:asosnovsky/helm-charts.git
metallb:
  addresses:
    - 10.0.100.1-10.0.100.255
enabledClusterSecretStores:
  - secrets
```

### `charts/apps` (deployed by the ApplicationSet)

Each folder is auto-deployed by the ApplicationSet into a namespace named after the folder. Value merge order: `values.yaml`, then `values-<deployment>.yaml` (`dev`/`prod`), then inline `global`.

| Chart | Purpose |
|-------|---------|
| `authelia` | SSO / authentication portal |
| `certs` | Certificate management (issuers for TLS) |
| `dummy` | Minimal example app |
| `ingress` | Reverse proxies, cluster services, and ingress rules (Traefik + Tailscale) |
| `torrents` | Torrenting stack |
| `argoapps` | **Not** a normal app — creates additional Argo CD Applications (see below) |

### `charts/apps/ingress`

Renders several kinds of resources from `reverseProxy`, `services`, and `tailScaleServices` values:

- **Reverse proxies** — `Endpoints` + `Service` pointing at an external IP (e.g. Jellyfin, Scrypted, a "castle" box), plus optional external ingress and/or a Tailscale ingress.
- **Services** — ingress rules for in-cluster services via the `homelab.ingress` helper.
- **Tailscale services** — ingress via `homelab.ingress.tailscale`.
- Also provisions an Argo CD `Application` for the **homepage** dashboard.

Example snippet (`values-prod.yaml`):

```yaml
reverseProxy:
  jellyfin:
    ip: 10.0.10.5
    port: 8096
services:
  - prefix: "auth"
    service: "authelia"
    namespace: "authelia"
    group: "Admin"
tailScaleServices:
  - name: "argocd"
    namespace: plugin-argo-cd
    selector: { "app.kubernetes.io/name": "argocd-server" }
    port: 8080
```

### `charts/apps/argoapps`

This is a special chart **needed by Argo CD itself** (bootstrapped via `infrastructure`), which then creates further Applications:

- `compose-apps.yaml` — for each file in `compose-apps/*.yaml`, generates an `Application` pointing at `charts/compose-app` in the external `helm-charts` repo. Each compose-app is essentially a Docker Compose stack (e.g. `arrs`, `immich`, `paperless-ngx`, `smartboi`) deployed into a `comap-<name>` namespace.
- `nfs.yaml` — an `Application` for the `nfs-subdir-external-provisioner` (external GitHub repo) hosting the NFS storage classes.

Compose-apps are defined as docker-compose files; examples:

| File | Stack |
|------|-------|
| `arrs.yaml` | Media stack: sonarr, radarr, lidarr, prowlarr, nzbget, flaresolverr + postgres |
| `immich.yaml` | Photo library |
| `paperless-ngx.yaml` | Document management |
| `smartboi.yaml` | Smart device assistant |

---

## Terraform module: `tf-modules/k8s-helm-charts`

A generic, reusable module that installs a map of Helm releases.

```hcl
module "k8s-helm-charts" {
  source  = "./tf-modules/k8s-helm-charts"
  plugins = {
    cert-manager = {
      repository = "https://charts.jetstack.io"
      version    = "1.19.2"
      values     = [yamlencode({ installCRDs = true })]
    }
    # ...
  }
}
```

- One `helm_release` per key, `create_namespace = true`, default namespace `plugin-<key>`.
- Exposes an output `namespaces.plugins.<key>` with each release's namespace (used elsewhere in the root config).

---

## Secrets Management

Secrets flow through multiple channels:

1. **Terraform provider vars** — declared `sensitive` in `tf-variables.tf`; supplied via `var.auto.tfvars`.
2. **Direct Kubernetes secrets** — e.g. the VPN credentials in `tf-secrets.tf`.
3. **Kubernetes secrets for Argo/plugins** — Cloudflare API token (`tf-ns-ingress.tf`/certs), git repo credentials (via the `infrastructure` chart).
4. **External Secrets Operator** — `es-cluster-store.yaml` creates a `ClusterSecretStore` per namespace (RBAC + ServiceAccount) so apps can pull secrets cross-namespace from e.g. the `secrets` namespace.

> **Security note:** `var.auto.tfvars` holds live credentials (Cloudflare tokens, GitHub SSH key, Tailscale OAuth, VPN creds). It is **correctly excluded from Git** by `.gitignore` (`*.tfvars*`) and is not tracked — verified with `git check-ignore`. Keep it out of version control. For additional hardening, consider moving these secrets off-disk to a secret manager (External Secrets + Vault) or encrypting the file with `sops`/`git-crypt`.

> **Also note:** the provider pin uses Helm `version = "3.0.0-pre1"` (a pre-release). Upgrade to a stable Helm provider release when possible.

---

## OS Configuration

### `os/raspberrypi2-raspbian`

Configuration for a Raspberry Pi 2 running Raspbian. This ARM device can't run Nix or the `linuxserver` docker images, so it's given a plain `compose.yaml` plus helper scripts. Contains a `systemd/` directory.

### `os/routers`

OpenWrt router configuration:

- `openwrt-mesh/` — mesh router setup in `main` or `ap` (access point) modes. `push.sh` copies the generated `create-<mode>.sh` + `.env` to the router over SSH and runs it. Requires a local `.env` (gitignored).
- `openwrt-themes/` — OpenWrt theme material overrides.

---

## GitHub Actions

`ossar.yml` runs the OSSAR static-analysis scan on the `stable` branch (push, PR, and weekly). Results are uploaded to the GitHub Security tab as SARIF.

---

## Contributing Workflow

1. **Add a chart:** `dev new-chart <name>` scaffolds `charts/apps/<name>` where Argo CD will deploy it into the `<name>` namespace.
2. **Set values:** provide `values.yaml` and `values-dev.yaml`/`values-prod.yaml` (see `insert` chart for a worked example).
3. **Deploy:** commit to the gitops branch configured in `charts/infrastructure/values.yaml` (`gitops.revision`); Argo CD's ApplicationSet picks it up automatically.
4. **Secrets:** store them behind External Secrets / a `ClusterSecretStore` rather than in tfvars.
5. **Validate locally:** `dev template <app>` renders the deployed chart for review before pushing.

---

## Common Tasks

| Task | Command |
|------|---------|
| Enter dev environment | `nix develop` |
| Plan / apply Terraform | `terraform plan` / `terraform apply` |
| Sync Argo app status | `kubectl -n plugin-argo-cd get applications.argoproj.io` |
| Render an app's Helm output | `dev template <app>` |
| Scaffold a new chart | `dev new-chart <name>` |
