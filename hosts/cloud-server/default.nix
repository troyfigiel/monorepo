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
