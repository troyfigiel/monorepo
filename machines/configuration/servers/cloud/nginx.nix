{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."troyfigiel.com" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [ "www.troyfigiel.com" ];
      locations."/" = { root = pkgs.website; };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "troy.figiel@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
