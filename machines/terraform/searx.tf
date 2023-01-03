resource "cloudflare_record" "search" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "search.troyfigiel.com"
  value   = "troyfigiel.com"
  type    = "CNAME"
}

resource "cloudflare_record" "www-search" {
  zone_id = cloudflare_zone.troyfigiel.id
  ttl     = 3600
  name    = "www.search.troyfigiel.com"
  value   = "troyfigiel.com"
  type    = "CNAME"
}
