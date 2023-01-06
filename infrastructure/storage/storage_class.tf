resource "kubernetes_storage_class" "local-storage" {
  metadata {
    name = var.local_storage_class_name
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
}
