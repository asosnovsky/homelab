
output "pvcs" {
  value = module.storage.pvc
}

output "db_user_secrets" {
  value = module.pg-users.secrets
}

output "redis_secret" {
  value = module.redis.redis_secret
}

output "namespace" {
  value = local.namespace
}
