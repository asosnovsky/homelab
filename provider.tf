terraform {
  backend "kubernetes" {
    secret_suffix = "homelab"
    config_path   = "~/.kube/config"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
  }
}

provider "helm" {}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
