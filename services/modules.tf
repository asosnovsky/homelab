module "nextcloud" {
  source = "./nextcloud"

  namespace      = var.namespace
  host           = "nextcloud.sosnovsky.ca"
  redis_secret   = var.redis_secret
  pvc            = var.pvcs.nextcloud.name
  db_user_secret = var.db_user_secrets.nextcloud.name
}

module "ingress" {
  source = "./ingress"

  namespace = var.namespace
  email     = "ariel@sosnovsky.ca"
  mode      = "dev"
  services = {
    "nextcloud" : {
      host = "nextcloud.sosnovsky.ca"
      port = {
        number = 8080
      }
    }
  }

}