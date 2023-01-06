resource "cloudflare_record" "troyfigiel" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "troyfigiel.com"
  value   = vultr_instance.cloud-server.main_ip
  type    = "A"
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "www.troyfigiel.com"
  value   = "troyfigiel.com"
  type    = "CNAME"
}
