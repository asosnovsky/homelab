module "storage" {
  source = "./storage"

  local_storage_class_name = local.local_storage_class
  namespace                = local.namespace
  volumes = {
    postgres = {
      storage        = "10Gi"
      node_name      = var.node_name_master
      data_path      = "${var.local_root_storage_path}/postgres"
      access_mode    = "ReadWriteOnce"
      reclaim_policy = "Delete"
    }
    redis = {
      storage        = "10Gi"
      node_name      = var.node_name_master
      data_path      = "${var.local_root_storage_path}/redis"
      access_mode    = "ReadWriteOnce"
      reclaim_policy = "Delete"
    }
    nextcloud = {
      storage     = "10Gi"
      node_name   = var.node_name_master
      data_path   = "${var.local_root_storage_path}/nextcloud"
      access_mode = "ReadWriteMany"
    }
    nextclouddata = {
      storage     = "50Gi"
      node_name   = var.node_name_master
      data_path   = "${var.local_root_storage_path}/nextcloud-data"
      access_mode = "ReadWriteMany"
    }
  }
}

module "postgres" {
  source = "./postgres"

  namespace = local.namespace
  pvc       = module.storage.pvc.postgres.name
  depends_on = [
    module.storage
  ]
}
module "redis" {
  source = "./redis"

  namespace = local.namespace
  pvc       = module.storage.pvc.redis.name

  depends_on = [
    module.storage
  ]
}
module "pg-users" {
  source = "./pg-users"

  namespace = local.namespace
  secret_db = module.postgres.db_secret
  users     = ["nextcloud"]

  depends_on = [
    module.postgres
  ]
}
module "cert-manager" {
  source = "./cert-manager"

  namespace = local.namespace
}
