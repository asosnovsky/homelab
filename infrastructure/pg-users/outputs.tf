data "kubernetes_secret" "pgs" {
  count = length(var.users)
  metadata {
    name      = "pg-password-${var.users[count.index]}"
    namespace = var.namespace
  }
  depends_on = [
    helm_release.users
  ]
}
output "secrets" {
  value = {
    for k, v in data.kubernetes_secret.pgs:
        var.users[k] => v.metadata[0]
  }
}