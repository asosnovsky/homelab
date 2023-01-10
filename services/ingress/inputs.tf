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
variable "mode" {}