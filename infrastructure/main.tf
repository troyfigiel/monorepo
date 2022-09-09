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

data "sops_file" "secrets" {
  source_file = "secrets.yaml"
  input_type  = "yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
  domain  = "troyfigiel.com"
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare_api_token
}

provider "vultr" {
  api_key = local.secrets.vultr_api_key
}