# resource "cloudflare_record" "mail" {
#   zone_id  = cloudflare_zone.troyfigiel.id
#   name     = "troyfigiel.com"
#   value    = "mail.troyfigiel.com"
#   type     = "MX"
#   priority = 10
# }

resource "cloudflare_record" "spf" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "troyfigiel.com"
  value   = "v=spf1 a:mail.troyfigiel.com -all"
  type    = "TXT"
}

resource "cloudflare_record" "dkim" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "mail._domainkey.troyfigiel.com"
  value   = "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5lgjEVq4IFn1kLnO+O6QxIfSMVUoJc/TdNhQs0W8FHATEvaSbvitn46p7UBgdVwyMvG6c+q2iVVzEcjKN6ziydYZaGlf0CZdstA/FXSfYGi/V6eMr2NtYB+TszM/WAslKD1YrsI0+fIpBvbJi2RR03QEFOen1M+XjP6cyeDsfCQIDAQAB"
  type    = "TXT"
}

resource "cloudflare_record" "dmarc" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "_dmarc.troyfigiel.com"
  value   = "v=DMARC1; p=none"
  type    = "TXT"
}
