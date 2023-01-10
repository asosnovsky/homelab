resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "nextcloud"
    namespace = var.namespace
  }

  spec {
    rule {
      host = var.host
      http {
        path {
          path_type = "Prefix"
          backend {
            service {
              name = "nextcloud"
              port {
                number = 8080
              }
            }
          }
          path = "/"
        }
      }
    }

    # tls {
    #   secret_name = "tls-secret"
    # }
  }
}