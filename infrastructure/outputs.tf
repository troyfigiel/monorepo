output "cloud-server_ip-address" {
  description = "Public IP address of my Vultr server."
  value       = vultr_instance.cloud-server.main_ip
}

output "website_domain" {
  description = "Domain name of my website."
  value       = "troyfigiel"
}

output "website_pqdn" {
  description = "Partially qualified domain name of my website."
  value       = "troyfigiel.com"
}
