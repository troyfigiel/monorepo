variable "domain" {
  type = string
  default = "troyfigiel.com"
}

resource "cloudflare_record" "www" {
  domain = "${var.domain}"
  name = "www"
  value = "..."
  type = "A"
  proxied = true
}
