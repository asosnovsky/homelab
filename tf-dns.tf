data "http" "myip" {
  url = "https://api.myip.com/"
}
data "cloudflare_zone" "this" {
  for_each = var.domain_mappings
  filter = {
    name = each.key
    account = {
      id = var.cloudflare.account_id
    }
  }
}


locals {
  myip = jsondecode(data.http.myip.response_body)["ip"]
  records = flatten([
    for zone, records in var.domain_mappings : [
      for r, def in records :
      {
        "zone" : zone,
        "record" : r,
        "type" : def.type != null ? def.type : "A",
        "ip" : def.ip != null ? def.ip : local.myip,
        "zone_id" : data.cloudflare_zone.this[zone].zone_id,
      }
    ]
  ])
  record_comment = "Updated by Terraform"
}

output "myip" {
  value = local.myip
}

resource "cloudflare_dns_record" "this" {
  for_each = {
    for d in local.records :
    "${d.record}.${d.zone}" => d
  }
  zone_id = each.value.zone_id
  comment = local.record_comment
  content = each.value.ip
  name    = each.key
  type    = each.value.type
  proxied = false
  ttl     = 1
}
