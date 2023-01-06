# resource "kubernetes_stateful_set" "pg" {
#   metadata {
#     name      = "postgres"
#     namespace = local.namespace
#   }
#   spec {
#     pod_management_policy = "OrderedReady"
#     replicas              = 1
#     service_name          = "postgres"
#     selector {
#       match_labels = {
#         k8s-app = "prometheus"
#       }
#     }
#     template {
#       metadata {
#         name = "postgres"
#       }
#       spec {
#         container {
#           name              = "main"
#           image             = "postgres:15.1-alpine"
#           image_pull_policy = "IfNotPresent"
#           port {
#             container_port = 5123
#           }
#           volume_mount {
#             name       = "postgres-data"
#             mount_path = "/var/lib/postgresql/data"
#             read_only  = false
#           }
#           resources {
#             limits = {
#               cpu    = "1"
#               memory = "2000Mi"
#             }
#             requests = {
#               cpu    = "200m"
#               memory = "100Mi"
#             }
#           }
#         }
#       }
#     }
#     volume_claim_template {
#       metadata {
#         name = "postgres-data"
#       }
#       spec {
#         storage_class_name = local.local_storage_class
#         access_modes       = ["ReadWriteOnce"]
#         volume_name        = kubernetes_persistent_volume.posgres.id
#         resources {
#           requests = {
#             "storage" = "10Gi"
#           }
#         }
#       }
#     }
#   }
# }


