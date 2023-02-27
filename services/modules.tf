module "nextcloud" {
  source = "./nextcloud"

  namespace      = var.namespace
  host           = "nextcloud.${var.root_dns}"
  redis_secret   = var.redis_secret
  pvc_data       = var.pvcs.nextclouddata.name
  db_user_secret = var.db_user_secrets.nextcloud.name
}

module "ingress" {
  source = "./ingress"

  namespace    = var.namespace
  email        = "ariel@sosnovsky.ca"
  staging_mode = var.ingress_staging_mode
  tls_enabled  = var.tls_enabled
  services = merge({
    "nextcloud" : {
      host = "nextcloud.${var.root_dns}"
      port = {
        number = 8080
      }
      # annotations = local.nextcloud_ingress_annotations
      tlsDisabled = true
    }
  }, local.reverse_proxies_ingress_def)
}
