{{- define "pg-users.terraform" -}}
variable "db_host" {}
variable "db_username" {}
variable "db_password" {}
variable "db_users" {
    type = list(string)
}
variable "db_port" {
  type = number
  default = 5432
}
variable "db_users_dbs" {
  type = map(list(string))
  default = {}
}
terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "{{.Values.terraform.cyrilgdnPostgresql.tag}}"
    }
  }
}

terraform {
  backend "kubernetes" {
    secret_suffix    = "{{ .Release.Name }}"
    in_cluster_config  = true
    namespace  = "{{ .Release.Namespace }}"
  }
}


provider "postgresql" {
  host            = var.db_host
  port            = var.db_port
  username        = var.db_username
  password        = var.db_password
  connect_timeout = 15
  sslmode         = "disable"
}

resource "random_password" "pg_users_pswd" {
  count = length(var.db_users)

  length           = 16
  special          = true
  override_special = "!#$%&"
}


locals {
  users = {
    for u, pwd in random_password.pg_users_pswd :
    var.db_users[u] => pwd.result
  }
  users_db = distinct(flatten([
    for user, dbs in var.db_users_dbs: [
      for db in dbs: {
        db = db
        user = user
      }
    ]
  ]))
}

resource "kubernetes_secret" "pg_users" {
  for_each = local.users
  metadata {
    name      = "password.pg.${each.key}"
    namespace = "{{ .Release.Namespace }}"
    annotations = {
      "managed-by": "job/user-generation"
    }
  }

  data = {
    username = each.key
    password = each.value
    host = var.db_host
    port = var.db_port
    additional_dbs = [
      for dbName in try(var.db_users_dbs[each.key], []):
        "${each.key}-${dbName}"
    ]
  }

  type = "Opaque"
}

resource "postgresql_role" "u" {
  for_each = local.users
  name     = each.key
  password = each.value
  login    = true
}

resource "postgresql_database" "db" {
  for_each = local.users
  name     = each.key
  owner    = postgresql_role.u[each.key].id
}

resource "postgresql_database" "db_users" {
  for_each = { for ud in local.users_db: "${ud.db}.${ud.user}" => ud }
  name     = "${ud.user}-${ud.db}"
  owner    = postgresql_role.u[each.value.user].id
}


{{- end -}}