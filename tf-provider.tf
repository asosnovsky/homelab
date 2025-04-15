terraform {
  backend "kubernetes" {
    secret_suffix  = "homelab"
    namespace      = "default"
    config_context = "homelab"
  }
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.2.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.5.2"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_context = "homelab"
  }
}
provider "kubernetes" {
  config_context = "homelab"
}
provider "http" {}
provider "cloudflare" {
  api_token = var.cloudflare.api_token
}
provider "argocd" {
  core = true
}
