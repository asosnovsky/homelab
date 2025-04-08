resource "helm_release" "plugins" {
  for_each         = var.plugins
  name             = each.key
  chart            = each.key
  repository       = each.value.repository
  version          = each.value.version
  atomic           = true
  namespace        = "plugin-${each.key}"
  create_namespace = true
}

resource "helm_release" "infra" {
  for_each         = var.infra
  name             = each.key
  chart            = each.key
  repository       = each.value.repository
  version          = each.value.version
  atomic           = true
  namespace        = "infra-${each.key}"
  create_namespace = true
}




