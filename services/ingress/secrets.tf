
# resource "kubernetes_secret" "cert" {
#   for_each = var.services
#   metadata {
#     name      = "homelab.ingress.cert.${each.key}"
#     namespace = var.namespace
#   }

#   data = {
#     "tls.key" : "",
#     "tls.crt" : "",
#   }

#   type = "kubernetes.io/tls"
# }



# resource "kubernetes_secret" "le" {
#   metadata {
#     name      = "ingress.letsencrypt"
#     namespace = var.namespace
#   }

#   data = {
#   }

#   type = "Opaque"
# }
