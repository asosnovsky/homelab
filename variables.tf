variable "cloudflare" {
  type = object({
    api_token  = string
    account_id = string
  })
}
variable "main_domain" {
  default = "sosnovsky.ca"
}
variable "secondary_domain" {
  default = "skyg.ca"
}
variable "domain_mappings" {
  type = map(map(object({
    ip   = optional(string),
    type = optional(string, "A"),
  })))
}
