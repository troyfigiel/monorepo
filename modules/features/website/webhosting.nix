{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.webserver;
in {
  imports = [ inputs.simple-nixos-mailserver.nixosModules.mailserver ];

  options.features.webserver.enable =
    mkEnableOption "Turn this machine into a webserver for my website.";

  config = let pqdn = "troyfigiel.com";
  in mkIf cfg.enable {
    sops.secrets = {
      searx-basic-auth-file = {
        # nginx needs to be able to read the basic-auth-file to perform the authentication.
        # TODO: Can I make this dependent on the nginx service?
        owner = "nginx";
      };
      searx-environment-file = { };
      mail-troy-password = { };
    };

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

      virtualHosts = {
        # TODO: Do I really need to write it like this? Seems superfluous.
        "${pqdn}" = {
          forceSSL = true;
          enableACME = true;
          serverAliases = [ "www.troyfigiel.com" ];
          locations."/" = { root = pkgs.website; };
        };

        "search.${pqdn}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = { proxyPass = "http://localhost:8080"; };
          basicAuthFile = config.sops.secrets.searx-basic-auth-file.path;
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "troy.figiel@gmail.com";
    };

    # TODO: Searx works, but I tend to get bad search results. I need to figure out how to improve that.
    # TODO: I am not sure how I can add Searx as my default search engine. It does not always seem to work properly. Is this because of the basic auth?
    services.searx = {
      enable = true;
      settings = {
        server = {
          port = 8080;
          bind_adress = "0.0.0.0";
          secret_key = "@SEARX_SECRET_KEY@";
        };
      };
      environmentFile = config.sops.secrets.searx-environment-file.path;
    };

    # TODO: I have not checked yet whether everything works.

    mailserver = {
      enable = true;
      fqdn = "mail.troyfigiel.com";
      domains = [ "troyfigiel.com" ];

      loginAccounts = {
        "troy@troyfigiel.com" = {
          hashedPasswordFile = config.sops.secrets.mail-troy-password.path;
        };
      };
    };
  };
}
