{{- define "pg-users.terraform" -}}
variable "db_host" {}
variable "db_username" {}
variable "db_password" {}
variable "db_users" {
    type = map(string)
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


resource "postgresql_role" "u" {
  for_each = var.db_users
  name     = each.key
  password = each.value
  login    = true
}

resource "postgresql_database" "db" {
  for_each = var.db_users
  name     = each.key
  owner    = postgresql_role.u[each.key].id
}

{{- end -}}