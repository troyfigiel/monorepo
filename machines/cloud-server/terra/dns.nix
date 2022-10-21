{ config, ... }:

let
  domain = "troyfigiel";
  pqdn = "${domain}.com";
  zone_id = "\${cloudflare_zone.${domain}.id}";
  ttl = 3600;
in {
  resource = {
    cloudflare_zone.${domain} = {
      zone = pqdn;
      account_id = config.locals.cloudflare_account_id;
    };

    cloudflare_record = {
      troyfigiel = {
        inherit zone_id ttl;
        name = pqdn;
        value = "\${vultr_instance.cloud-server.main_ip}";
        type = "A";
      };

      www = {
        inherit zone_id ttl;
        name = "www.${pqdn}";
        value = pqdn;
        type = "CNAME";
      };

      search = {
        inherit zone_id ttl;
        name = "search.${pqdn}";
        value = pqdn;
        type = "CNAME";
      };

      www-search = {
        inherit zone_id ttl;
        name = "www.search.${pqdn}";
        value = pqdn;
        type = "CNAME";
      };

      # TODO: Why do I need this again?
      sub = {
        inherit zone_id ttl;
        name = "*.${pqdn}";
        value = "\${vultr_instance.cloud-server.main_ip}";
        type = "A";
      };

      mail = {
        inherit zone_id;
        name = pqdn;
        value = "mail.${pqdn}";
        type = "MX";
        priority = 10;
      };

      spf = {
        inherit zone_id ttl;
        name = pqdn;
        value = "v=spf1 a:mail.${pqdn} -all";
        type = "TXT";
      };

      dkim = {
        inherit zone_id ttl;
        name = "mail._domainkey.${pqdn}";
        value =
          "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5lgjEVq4IFn1kLnO+O6QxIfSMVUoJc/TdNhQs0W8FHATEvaSbvitn46p7UBgdVwyMvG6c+q2iVVzEcjKN6ziydYZaGlf0CZdstA/FXSfYGi/V6eMr2NtYB+TszM/WAslKD1YrsI0+fIpBvbJi2RR03QEFOen1M+XjP6cyeDsfCQIDAQAB";
        type = "TXT";
      };

      dmarc = {
        inherit zone_id ttl;
        name = "_dmarc.${pqdn}";
        value = "v=DMARC1; p=none";
        type = "TXT";
      };
    };
  };
}
