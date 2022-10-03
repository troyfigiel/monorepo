data "vultr_snapshot" "nixos-snapshot" {
  filter {
    name   = "description"
    values = ["cloud-server"]
  }
}

resource "vultr_iso_private" "nixos-22-05" {
  url = "https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso"
}

resource "vultr_instance" "cloud-server" {
  plan             = "vc2-1c-1gb"
  region           = "fra"
  snapshot_id      = data.vultr_snapshot.nixos-snapshot.id
  activation_email = false
  ddos_protection  = false
  label            = "cloud-server"
}

resource "vultr_reverse_ipv4" "cloud-server_reverse_ipv4" {
  instance_id = vultr_instance.cloud-server.id
  ip          = vultr_instance.cloud-server.main_ip
  reverse     = "mail.${local.domain}"
}
