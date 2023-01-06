module "storage" {
  source = "./storage"

  local_storage_class_name = local.local_storage_class
  namespace                = local.namespace
  volumes = {
    postgres = {
      storage   = "10Gi"
      node_name = var.node_name_master
      data_path = "${var.local_root_storage_path}/postgres"
    }
  }
}

output "pvc" {
  value = module.storage.pvc
}
