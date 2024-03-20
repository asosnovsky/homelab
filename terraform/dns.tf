data "cloudflare_zone" "this" {
  for_each = var.domain_mappings
  name     = each.key
}

locals {
  records = flatten([
    for zone, records in var.domain_mappings : [
      for r, def in records :
      {
        "zone" : zone,
        "record" : r,
        "type" : def.type != null ? def.type : "A",
        "ip" : def.ip != null ? def.ip : var.myip,
        "zone_id" : data.cloudflare_zone.this[zone].id,
      }
    ]
  ])
  current_date   = formatdate("YYYY-MM-DD", timestamp())
  record_comment = "Updated by Terraform at ${local.current_date}"
}

resource "cloudflare_record" "this" {
  for_each = {
    for d in local.records :
    "${d.record}.${d.zone}" => d
  }
  zone_id = each.value.zone_id
  name    = each.value.record
  value   = each.value.ip
  comment = local.record_comment
  type    = each.value.type
  proxied = false
}