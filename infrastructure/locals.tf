locals {
  namespace           = kubernetes_namespace.hl.id
  local_storage_class = "local-storage"
  # pg_cluster_ip       = data.kubernetes_service.pg.spec[0].cluster_ip
}
