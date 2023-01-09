terraform {
  required_providers {
    b2 = {
      source = "Backblaze/b2"
    }

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
  b2_application_key    = data.sops_file.secrets.data["b2_application_key"]
  b2_application_key_id = data.sops_file.secrets.data["b2_application_key_id"]
  cloudflare_api_token  = data.sops_file.secrets.data["cloudflare_api_token"]
  cloudflare_account_id = data.sops_file.secrets.data["cloudflare_account_id"]
  vultr_api_key         = data.sops_file.secrets.data["vultr_api_key"]
}

provider "b2" {
  application_key    = local.b2_application_key
  application_key_id = local.b2_application_key_id
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "vultr" {
  api_key = local.vultr_api_key
}
