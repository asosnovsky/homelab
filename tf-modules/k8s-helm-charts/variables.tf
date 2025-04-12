variable "plugins" {
  type = map(object({
    repository = string
    version    = string
    values     = optional(list(string), [])
  }))
  default = {}
}


variable "infra" {
  type = map(object({
    repository = string
    version    = string
    values     = optional(list(string), [])
  }))
  default = {}
}
