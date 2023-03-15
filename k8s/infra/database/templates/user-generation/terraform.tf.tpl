{{- define "pg-users.terraform" -}}
variable "db_host" {}
variable "db_username" {}
variable "db_password" {}
variable "db_users" {
    type = list(string)
}
terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.18.0"
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
  port            = 5432
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
}

resource "kubernetes_secret" "pg_users" {
  for_each = local.users
  metadata {
    name      = "password.pg.${each.key}"
    namespace = var.namespace
  }

  data = {
    username = each.key
    password = each.value
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


{{- end -}}