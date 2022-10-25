{ config, lib, ... }:

with lib;
let cfg = config.my.records.webhosting;
in {
  options.my.records.webhosting = {
    enable = mkEnableOption "Enable website records.";

    domain = mkOption {
      type = types.str;
      description = "Domain.";
    };

    pqdn = mkOption {
      type = types.str;
      description = "Partially qualified domain name.";
    };
  };

  config = let
    zone_id = "\${cloudflare_zone.${cfg.domain}.id}";
    ttl = 3600;
  in mkIf cfg.enable {
    resource = {
      cloudflare_zone.${cfg.domain} = {
        zone = cfg.pqdn;
        account_id = config.locals.cloudflare_account_id;
      };

      cloudflare_record = {
        troyfigiel = {
          inherit zone_id ttl;
          name = cfg.pqdn;
          value = "\${vultr_instance.cloud-server.main_ip}";
          type = "A";
        };

        www = {
          inherit zone_id ttl;
          name = "www.${cfg.pqdn}";
          value = cfg.pqdn;
          type = "CNAME";
        };

        # TODO: Why do I need this again?
        sub = {
          inherit zone_id ttl;
          name = "*.${cfg.pqdn}";
          value = "\${vultr_instance.cloud-server.main_ip}";
          type = "A";
        };
      };
    };
  };
}

