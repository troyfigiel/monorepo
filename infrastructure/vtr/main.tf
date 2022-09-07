terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }

    vultr = {
      source = "vultr/vultr"
    }

    sops = {
      source = "carlpett/sops"
    }
  }
}
