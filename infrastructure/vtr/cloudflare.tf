provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

variable "domain" {
  type    = string
  default = "troyfigiel.com"
}

resource "cloudflare_zone" "troyfigiel" {
  zone       = var.domain
  account_id = local.cloudflare_account_id
}

resource "cloudflare_record" "troyfigiel" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = var.domain
  value   = vultr_instance.vtr.main_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "www.${var.domain}"
  value   = var.domain
  type    = "CNAME"
  ttl     = 3600
}
