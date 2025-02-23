terraform {
  backend "kubernetes" {
    secret_suffix = "homelab"
    namespace     = "default"
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
      version = "5.1.0"
    }
  }
}

provider "helm" {}
provider "kubernetes" {}
provider "http" {}
provider "cloudflare" {
  api_token = var.cloudflare.api_token
}
