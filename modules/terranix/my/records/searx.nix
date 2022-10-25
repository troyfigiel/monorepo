{ config, lib, ... }:

with lib;
let cfg = config.my.records.searx;
in {
  options.my.records.searx = {
    enable = mkEnableOption "Enable Searx records.";

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
        search = {
          inherit zone_id ttl;
          name = "search.${cfg.pqdn}";
          value = cfg.pqdn;
          type = "CNAME";
        };

        www-search = {
          inherit zone_id ttl;
          name = "www.search.${cfg.pqdn}";
          value = cfg.pqdn;
          type = "CNAME";
        };
      };
    };
  };
}

