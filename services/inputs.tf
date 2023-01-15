variable "namespace" {}
variable "redis_secret" {}
variable "root_dns" {}
variable "db_user_secrets" {
  type = map(object({
    name      = string
    namespace = string
  }))
}
variable "pvcs" {
  type = map(object({
    name      = string
    namespace = string
  }))
}
