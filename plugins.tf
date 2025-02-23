resource "helm_release" "plugin-external-secrets" {
  name             = "external-secrets"
  chart            = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  version          = "0.14.2"
  atomic           = true
  namespace        = "plugin-external-secrets"
  create_namespace = true
}


resource "helm_release" "plugin-metallb" {
  name             = "metallb"
  chart            = "metallb"
  repository       = "https://metallb.github.io/metallb"
  version          = "0.14.9"
  atomic           = true
  namespace        = "plugin-metallb"
  create_namespace = true
}

resource "helm_release" "local-chart-infrastructure" {
  name      = "infrastructure"
  chart     = "charts/infrastructure"
  namespace = "default"
  set = [{
    name  = "ns.metallb"
    value = helm_release.plugin-metallb.namespace
  }]
}
