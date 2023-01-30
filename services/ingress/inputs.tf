variable "namespace" {}
variable "services" {
  type = map(object({
    host = string,
    port = optional(object({
      number = number,
      }), {
      number = 80
    })
    path = optional(string, "/"),
  }))
  default = {}
}
variable "email" {}
variable "staging_mode" {
  type = bool
}
variable "tls_enabled" {
  type = bool
}