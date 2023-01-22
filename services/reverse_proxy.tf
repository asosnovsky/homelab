resource "kubernetes_endpoints" "rp" {
  for_each = var.reverse_proxies
  metadata {
    name      = "homelab-rev-proxy-${each.key}"
    namespace = var.namespace
  }

  subset {
    address {
      ip = each.value.ip
    }

    port {
      port     = each.value.port
      protocol = "TCP"
    }

  }
}

resource "kubernetes_service" "rp" {
  for_each = var.reverse_proxies
  metadata {
    name      = kubernetes_endpoints.rp[each.key].metadata.0.name
    namespace = var.namespace
  }

  spec {
    port {
      port        = 80
      target_port = each.value.port
    }
  }
}

locals {
  reverse_proxies_ingress_def = {
    for k, v in kubernetes_service.rp :
    v.metadata[0].name => {
      host = coalesce(var.reverse_proxies[k].host, "${k}.${var.root_dns}"),
      port = {
        number = coalesce(var.reverse_proxies[k].to_port, 80)
      }
    }
  }
}