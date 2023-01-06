locals {
  namespace           = kubernetes_namespace.hl.id
  local_storage_class = "local-storage"
}
