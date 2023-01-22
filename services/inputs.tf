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
variable "reverse_proxies" {
  type = map(object({
    ip      = string
    port    = string
    host    = optional(string)
    to_port = optional(string)
  }))
}