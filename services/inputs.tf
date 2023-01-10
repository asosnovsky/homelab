variable "namespace" {}
variable "redis-secret-name" {}
variable "db-user-secrets" {
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
