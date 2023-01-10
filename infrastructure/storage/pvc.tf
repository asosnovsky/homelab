resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = var.volumes
  metadata {
    name      = each.key
    namespace = var.namespace
  }
  spec {
    storage_class_name = kubernetes_storage_class.local-storage.metadata.0.name
    access_modes       = [each.value.access_mode]
    resources {
      requests = {
        storage = each.value.storage
      }
    }
    volume_name = kubernetes_persistent_volume.pv[each.key].metadata.0.name
  }
}
