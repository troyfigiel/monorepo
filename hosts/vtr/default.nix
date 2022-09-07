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
      [ (builtins.readFile ../ins/users/troy/keys/troy.pub.ssh) ];
  };

  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ git vim hello ];
    openssh.authorizedKeys.keys =
      [ (builtins.readFile ../ins/users/troy/keys/troy.pub.ssh) ];
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

    secrets = { acme-email-address = { }; };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "troyfigiel.com" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.troyfigiel.com" ];
        locations."/" = { root = "/var/www/troyfigiel.com"; };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = config.sops.secrets.acme-email-address.path;
  };

  environment.systemPackages = with pkgs; [ git vim gnupg ];

  system.stateVersion = "22.05";
}

