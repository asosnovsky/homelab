resource "kubernetes_persistent_volume" "pv" {
  for_each = var.volumes
  metadata {
    name = each.key
  }
  spec {
    capacity = {
      storage = each.value.storage
    }
    storage_class_name               = kubernetes_storage_class.local-storage.metadata.0.name
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values = [
              each.value.node_name
            ]
          }
        }
      }
    }
    persistent_volume_source {
      local {
        path = each.value.data_path
      }
    }
  }
}
