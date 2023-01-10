module "nextcloud" {
  source = "./nextcloud"

  namespace           = var.namespace
  host                = "nextcloud.sosnovsky.ca"
  redis-secret-name   = var.redis-secret-name
  pvc                 = var.pvcs.nextcloud.name
  db-user-secret-name = var.db-user-secrets.nextcloud.name
}
