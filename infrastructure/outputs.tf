
output "pvc" {
  value = module.storage.pvc
}

output "db-user-secrets" {
  value = module.pg-users.secrets
}