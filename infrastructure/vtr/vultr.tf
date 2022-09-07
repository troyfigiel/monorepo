provider "vultr" {
  api_key = local.vultr_api_key
}

data "vultr_snapshot" "nixos-snapshot" {
  filter {
    name   = "description"
    values = ["vtr"]
  }
}

resource "vultr_iso_private" "nixos-22-05" {
  url = "https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso"
}

resource "vultr_instance" "vtr" {
  plan             = "vc2-1c-1gb"
  region           = "fra"
  snapshot_id      = data.vultr_snapshot.nixos-snapshot.id
  activation_email = false
  ddos_protection  = false
  label            = "vtr"
}

resource "vultr_reverse_ipv4" "vtr_reverse_ipv4" {
    instance_id = vultr_instance.vtr.id
    ip = vultr_instance.vtr.main_ip
    reverse = "mail.${var.domain}"
}