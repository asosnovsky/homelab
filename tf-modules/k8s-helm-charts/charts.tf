resource "helm_release" "plugins" {
  for_each         = var.plugins
  name             = each.key
  chart            = each.value.chart == "" ? each.key : each.value.chart
  repository       = each.value.repository
  version          = each.value.version
  atomic           = true
  namespace        = each.value.namespace == "" ? "plugin-${each.key}" : each.value.namespace
  create_namespace = true
  values           = each.value.values
}

