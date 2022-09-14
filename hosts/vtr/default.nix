{ config, pkgs, ... }:

let sshPath = "/etc/ssh";
in {
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "vtr";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys =
      [ (builtins.readFile ../../keys/troy.pub.ssh) ];
  };

  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ git vim ];
    openssh.authorizedKeys.keys =
      [ (builtins.readFile ../../keys/troy.pub.ssh) ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;

    hostKeys = [
      {
        bits = 4096;
        path = "${sshPath}/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${sshPath}/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    gnupg.sshKeyPaths = [ "${sshPath}/ssh_host_rsa_key" ];
    age.sshKeyPaths = [ ];

    secrets = {
      acme-email-address = { };
      mail-troy-password = { };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "troyfigiel.com" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.troyfigiel.com" ];
        locations."/" = { root = pkgs.troyfigiel-com; };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = config.sops.secrets.acme-email-address.path;
  };

  environment.systemPackages = with pkgs; [ git vim gnupg ];

  #   mailserver = {
  #     enable = true;
  #     fqdn = "mail.troyfigiel.com";
  #     domains = [ "troyfigiel.com" ];
  #     # TODO: I have not been able to set up SSL/TLS yet.
  #     #certificateScheme = 3;

  #     loginAccounts = {
  #       "troy@troyfigiel.com" = {
  #         hashedPasswordFile = config.sops.secrets.mail-troy-password.path;
  #       };
  #     };
  #   };

  system.stateVersion = "22.05";
}
