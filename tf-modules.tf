
resource "helm_release" "local-chart-infrastructure" {
  name      = "infrastructure"
  chart     = "charts/infrastructure"
  namespace = "default"
  set = [
    {
      name  = "ns.metallb"
      value = module.k8s-helm-charts.namespaces.plugins.metallb
    },
    {
      name  = "ns.argocd"
      value = module.k8s-helm-charts.namespaces.plugins.argo-cd
    },
    {
      name  = "gitops.sshkey"
      value = var.ssh_key
    },
    {
      name  = "additionalRepos.github-helm-charts.sshkey"
      value = var.github_ssh_key
    }
  ]
  values = [
    yamlencode({
      "global" : var.globals
    })
  ]
  timeout       = 120
  force_update  = true
  lint          = true
  wait          = true
  wait_for_jobs = true
  max_history   = 4
}

module "k8s-helm-charts" {
  source = "./tf-modules/k8s-helm-charts"
  plugins = {
    "external-secrets" : {
      repository = "https://charts.external-secrets.io"
      version    = "0.16.1"
    },
    "metallb" : {
      repository = "https://metallb.github.io/metallb"
      version    = "0.14.9"
    },
    "cert-manager" : {
      repository = "https://charts.jetstack.io"
      version    = "1.18.2"
      values : [yamlencode({
        installCRDs : true
      })]
    },
    "argo-cd" : {
      "repository" : "https://argoproj.github.io/argo-helm"
      "version" : "7.9.0"
      "values" : [
        yamlencode({
          configs = {
            cm = {
              "exec.enabled" : true
            }
            params = {
              "server.insecure" = true
              "server.basehref" = "/"
              "server.rootpath" = ""
              "server.disable.auth" : true
            }
          }
          crds = {
            install = true
            keep    = false
          }
          server = {
            ingress = {
              enabled = false
            }
            ingressGrpc = {
              enabled = false
            }
          }
        })
      ]
    },
    "tailscale-operator" : {
      repository = "https://pkgs.tailscale.com/helmcharts"
      version    = "1.82.0"
      values : [
        yamlencode({
          oauth = {
            clientId     = var.tailscale.client_id
            clientSecret = var.tailscale.client_secret
          }
        })
      ]
    },
    "traefik" : {
      repository = "https://traefik.github.io/charts"
      version    = "35.0.1"
      values = [
        yamlencode({
          providers : {
            kubernetesGateway : {
              enabled : true
            }
          }
        })
      ]
    }
  }
}

output "ns" {
  value = module.k8s-helm-charts.namespaces
}


resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}
