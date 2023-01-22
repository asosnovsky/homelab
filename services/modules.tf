module "nextcloud" {
  source = "./nextcloud"

  namespace      = var.namespace
  host           = "nextcloud.${var.root_dns}"
  redis_secret   = var.redis_secret
  pvc            = var.pvcs.nextcloud.name
  db_user_secret = var.db_user_secrets.nextcloud.name
}

module "ingress" {
  source = "./ingress"

  namespace = var.namespace
  email     = "ariel@sosnovsky.ca"
  mode      = "dev"
  services = merge({
    "nextcloud" : {
      host = "nextcloud.${var.root_dns}"
      port = {
        number = 8080
      }
    }
  }, local.reverse_proxies_ingress_def)
}