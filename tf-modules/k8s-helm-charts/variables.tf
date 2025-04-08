variable "plugins" {
  type = map(object({
    repository = string
    version    = string
    values     = optional(list(string), [])
  }))
  default = {
    "external-secrets" : {
      repository = "https://charts.external-secrets.io"
      version    = "0.14.2"
    },
    "metallb" : {
      repository = "https://metallb.github.io/metallb"
      version    = "0.14.9"
    }
  }
}


variable "infra" {
  type = map(object({
    repository = string
    version    = string
    values     = optional(list(string), [])
  }))
  default = {}
}
