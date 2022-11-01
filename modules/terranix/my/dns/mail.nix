{ config, lib, ... }:

with lib;
let cfg = config.my.records.mail;
in {
  options.my.records.mail = {
    enable = mkEnableOption "Enable mail records.";

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
        mail = {
          inherit zone_id;
          name = cfg.pqdn;
          value = "mail.${cfg.pqdn}";
          type = "MX";
          priority = 10;
        };

        spf = {
          inherit zone_id ttl;
          name = cfg.pqdn;
          value = "v=spf1 a:mail.${cfg.pqdn} -all";
          type = "TXT";
        };

        dkim = {
          inherit zone_id ttl;
          name = "mail._domainkey.${cfg.pqdn}";
          value =
            "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5lgjEVq4IFn1kLnO+O6QxIfSMVUoJc/TdNhQs0W8FHATEvaSbvitn46p7UBgdVwyMvG6c+q2iVVzEcjKN6ziydYZaGlf0CZdstA/FXSfYGi/V6eMr2NtYB+TszM/WAslKD1YrsI0+fIpBvbJi2RR03QEFOen1M+XjP6cyeDsfCQIDAQAB";
          type = "TXT";
        };

        dmarc = {
          inherit zone_id ttl;
          name = "_dmarc.${cfg.pqdn}";
          value = "v=DMARC1; p=none";
          type = "TXT";
        };
      };
    };
  };
}
