# data "kubernetes_service" "pg" {
#   metadata {
#     name      = "postgres"
#     namespace = local.namespace
#   }
#   depends_on = [
#     module.postgres
#   ]
# }

# data "kubernetes_secret" "pg-password" {
#   metadata {
#     name      = "pg-password"
#     namespace = local.namespace
#   }
#   depends_on = [
#     module.postgres
#   ]
# }

# provider "postgresql" {
#   host            = local.pg_cluster_ip
#   port            = 5432
#   username        = data.kubernetes_secret.pg-password.data.username
#   password        = data.kubernetes_secret.pg-password.data.password
#   connect_timeout = 15
# }

# resource "random_password" "pg_users_pswd" {
#   count = length(var.db_users)

#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# resource "kubernetes_secret" "pg_users" {
#   count = length(var.db_users)
#   metadata {
#     name      = "pg-password-${var.db_users[count.index]}"
#     namespace = local.namespace
#   }

#   data = {
#     username = var.db_users[count.index]
#     password = random_password.pg_users_pswd[count.index].result
#   }

#   type = "Opaque"
# }
# resource "postgresql_role" "u" {
#   count    = length(var.db_users)
#   name     = var.db_users[count.index]
#   password = random_password.pg_users_pswd[count.index + 1].result
# }

# resource "postgresql_database" "db" {
#   count = length(var.db_users)

#   name  = var.db_users[count.index]
#   owner = postgresql_role.u[count.index].id
# }
