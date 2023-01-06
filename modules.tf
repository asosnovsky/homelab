variable "local_root_storage_path" {}
variable "node_name_master" {}
variable "node_name_nas" {}
module "infra" {
  source = "./infrastructure"

  local_root_storage_path = var.local_root_storage_path
  node_name_master        = var.node_name_master
  node_name_nas           = var.node_name_nas
}


output "pvc" {
  value = module.infra.pvc
}
