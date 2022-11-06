resource "cloudflare_zone" "troyfigiel" {
  zone       = "troyfigiel.com"
  account_id = local.cloudflare_account_id
}
