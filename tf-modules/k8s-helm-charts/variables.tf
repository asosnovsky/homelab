variable "plugins" {
  type = map(object({
    repository = string
    version    = optional(string)
    values     = optional(list(string), [])
    chart      = optional(string, "")
    namespace  = optional(string, "")
  }))
  default = {}
}
