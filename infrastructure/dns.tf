resource "cloudflare_zone" "troyfigiel" {
  zone       = local.domain
  account_id = local.secrets.cloudflare_account_id
}

resource "cloudflare_record" "troyfigiel" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = local.domain
  value   = vultr_instance.cloud-server.main_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "www.${local.domain}"
  value   = local.domain
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "search" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "search.${local.domain}"
  value   = local.domain
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "www-search" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "www.search.${local.domain}"
  value   = local.domain
  type    = "CNAME"
  ttl     = 3600
}

# TODO: Why do I need this again?
resource "cloudflare_record" "sub" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "*.${local.domain}"
  value   = vultr_instance.cloud-server.main_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "mail" {
  zone_id  = cloudflare_zone.troyfigiel.id
  name     = local.domain
  value    = "mail.${local.domain}"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "spf" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = local.domain
  value   = "v=spf1 a:mail.${local.domain} -all"
  type    = "TXT"
  ttl     = 3600
}

resource "cloudflare_record" "dkim" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "mail._domainkey.${local.domain}"
  value   = "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5lgjEVq4IFn1kLnO+O6QxIfSMVUoJc/TdNhQs0W8FHATEvaSbvitn46p7UBgdVwyMvG6c+q2iVVzEcjKN6ziydYZaGlf0CZdstA/FXSfYGi/V6eMr2NtYB+TszM/WAslKD1YrsI0+fIpBvbJi2RR03QEFOen1M+XjP6cyeDsfCQIDAQAB"
  type    = "TXT"
  ttl     = 3600
}

resource "cloudflare_record" "dmarc" {
  zone_id = cloudflare_zone.troyfigiel.id
  name    = "_dmarc.${local.domain}"
  value   = "v=DMARC1; p=none"
  type    = "TXT"
  ttl     = 3600
}
