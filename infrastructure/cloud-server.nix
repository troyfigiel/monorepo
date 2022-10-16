let
  machine = "cloud-server";
  pqdn = "troyfigiel.com";
in {
  data.vultr_snapshot.nixos-snapshot = {
    filter = {
      name = "description";
      values = [ machine ];
    };
  };

  resource = {
    vultr_iso_private.nixos-22-05.url =
      "https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso";

    vultr_instance.${machine} = {
      plan = "vc2-1c-1gb";
      region = "fra";
      snapshot_id = "\${data.vultr_snapshot.nixos-snapshot.id}";
      activation_email = false;
      ddos_protection = false;
      label = machine;
    };

    vultr_reverse_ipv4."${machine}_reverse_ipv4" = {
      instance_id = "\${vultr_instance.${machine}.id}";
      ip = "\${vultr_instance.${machine}.main_ip}";
      reverse = "mail.${pqdn}";
    };
  };
}
