provider "cloudflare" {
  api_token = local.cloudflare_api_token
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

resource "cloudflare_record" "sub" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "*.${var.domain}"
  value   = vultr_instance.vtr.main_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "mail" {
  zone_id  = cloudflare_zone.troyfigiel.id
  name     = var.domain
  value    = "mail.${var.domain}"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "spf" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = var.domain
  value   = "v=spf1 a:mail.${var.domain} -all"
  type    = "TXT"
  ttl     = 3600
}

resource "cloudflare_record" "dkim" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "mail._domainkey.${var.domain}"
  value   = "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5lgjEVq4IFn1kLnO+O6QxIfSMVUoJc/TdNhQs0W8FHATEvaSbvitn46p7UBgdVwyMvG6c+q2iVVzEcjKN6ziydYZaGlf0CZdstA/FXSfYGi/V6eMr2NtYB+TszM/WAslKD1YrsI0+fIpBvbJi2RR03QEFOen1M+XjP6cyeDsfCQIDAQAB"
  type    = "TXT"
  ttl     = 3600
}

resource "cloudflare_record" "dmarc" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "_dmarc.${var.domain}"
  value   = "v=DMARC1; p=none"
  type    = "TXT"
  ttl     = 3600
}
