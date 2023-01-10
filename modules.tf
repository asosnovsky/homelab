variable "local_root_storage_path" {}
variable "node_name_master" {}
variable "node_name_nas" {}
module "infra" {
  source = "./infrastructure"

  local_root_storage_path = var.local_root_storage_path
  node_name_master        = var.node_name_master
  node_name_nas           = var.node_name_nas
  db_users                = ["nextcloud"]
}

module "services" {
  source = "./services"

  namespace         = module.infra.namespace
  redis-secret-name = module.infra.redis_secret
  db-user-secrets   = module.infra.db_user_secrets
  pvcs              = module.infra.pvcs
}

output "infra" {
  value = module.infra
}
