{ config, inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/locale.nix
    ../shared/nix.nix
    ../shared/sops.nix
    inputs.simple-nixos-mailserver.nixosModules.mailserver
  ];

  environment.systemPackages = with pkgs; [ git vim gnupg ];
  system.stateVersion = "22.05";

  users.users = {
    root = {
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../assets/keys/troy.pub.ssh) ];
    };

    nixos = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ git vim ];
    };
  };

  services.openssh.permitRootLogin = "yes";

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
      "troyfigiel.com" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.troyfigiel.com" ];
        locations."/" = { root = pkgs.website; };
      };

      "search.troyfigiel.com" = {
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
  sops.secrets = {
    searx-basic-auth-file = {
      # nginx needs to be able to read the basic-auth-file to perform the authentication.
      # TODO: Can I make this dependent on the nginx service?
      owner = "nginx";
    };
    searx-environment-file = { };
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

  # TODO: I have not checked yet whether everything works.
  sops.secrets.mail-troy-password = { };

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
}
