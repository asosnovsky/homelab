variable "myip" {
  default = ""
}
variable "cloudflare" {
  sensitive = true
  type = object({
    api_token    = string
    account_id   = string
    cm_api_token = string
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
variable "ssh_key" {
  sensitive = true
}
variable "github_ssh_key" {
  sensitive = true
}
variable "tailscale" {
  type = object({
    client_id     = string,
    client_secret = string,
  })
  sensitive = true
}
variable "vpn" {
  type = object({
    user     = string,
    password = string,
    provider = string,
    country  = string,
  })
  sensitive = true

}

variable "globals" {
  type = object({
    deployment = string
    email      = string
    timezone   = string

    dns = object({
      internalPrefix = string
      primary = object({
        domain = string
        root   = optional(string, "")
      })
      secondary = object({
        domain = string
        root   = optional(string, "")
      })
      tls = object({
        enabled       = bool
        useWildCard   = optional(bool, true)
        skipTLSVerify = optional(bool, true)
        issuer        = optional(string, "letsencrypt")
        acmeServer    = optional(string, "https://acme-v02.api.letsencrypt.org/directory")
      })
    })
    nfs = object({
      storageClassName = string
      directMounts = object({
        server = string
        path   = string
      })
      storageProvider = object({
        server = string
        path   = string
      })
    })
    smtp = object({
      email = string
    })
  })
}
