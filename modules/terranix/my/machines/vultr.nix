{ config, lib, ... }:

with lib;
let cfg = config.my.machines.vultr;
in {
  options.my.machines.vultr = {
    enable = mkEnableOption "Enable vultr machine.";

    machine = mkOption {
      type = types.str;
      description = "Name of the machine.";
    };

    pqdn = mkOption {
      type = types.str;
      description = "Partially qualified domain name.";
    };
  };

  config = mkIf cfg.enable {
    data.vultr_snapshot.nixos-snapshot = {
      filter = {
        name = "description";
        values = [ cfg.machine ];
      };
    };

    resource = {
      vultr_iso_private.nixos-22-05.url =
        "https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso";

      vultr_instance.${cfg.machine} = {
        plan = "vc2-1c-1gb";
        region = "fra";
        snapshot_id = "\${data.vultr_snapshot.nixos-snapshot.id}";
        activation_email = false;
        ddos_protection = false;
        label = cfg.machine;
      };

      vultr_reverse_ipv4."${cfg.machine}_reverse_ipv4" = {
        instance_id = "\${vultr_instance.${cfg.machine}.id}";
        ip = "\${vultr_instance.${cfg.machine}.main_ip}";
        reverse = "mail.${cfg.pqdn}";
      };
    };
  };
}

