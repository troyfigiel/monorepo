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
  cloudflare_api_token  = data.sops_file.secrets.data["cloudflare_api_token"]
  cloudflare_account_id = data.sops_file.secrets.data["cloudflare_account_id"]
  vultr_api_key         = data.sops_file.secrets.data["vultr_api_key"]
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "vultr" {
  api_key = local.vultr_api_key
}
