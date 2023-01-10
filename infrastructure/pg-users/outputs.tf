output "secrets" {
  value = {
    for k, v in kubernetes_secret.pg_users:
      k => v.metadata[0]
  }
}