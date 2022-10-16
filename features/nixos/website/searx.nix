{ config, lib, ... }:

with lib;
let cfg = config.features.searx;
in {
  options.features.searx.enable = mkEnableOption "Searx";

  config = mkIf cfg.enable {
    # TODO: Searx works, but I tend to get bad search results. I need to figure out how to improve that.
    # TODO: I am not sure how I can add Searx as my default search engine. It does not always seem to work properly. Is this because of the basic auth?
    sops.secrets = {
      searx-basic-auth-file = {
        # nginx needs to be able to read the basic-auth-file to perform the authentication.
        # TODO: Can I make this dependent on the nginx service?
        owner = "nginx";
      };
      searx-environment-file = { };
    };

    services.nginx.virtualHosts."search.troyfigiel.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { proxyPass = "http://localhost:8080"; };
      basicAuthFile = config.sops.secrets.searx-basic-auth-file.path;
    };

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
  };
}
