{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.website;
in {
  options.my.website.enable = mkEnableOption "Website";

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "troy.figiel@gmail.com";
    };

    services.nginx.virtualHosts."troyfigiel.com" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [ "www.troyfigiel.com" ];
      locations."/" = { root = pkgs.website; };
    };
  };
}
