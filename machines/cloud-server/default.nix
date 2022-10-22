{ inputs, nixosFeatures, pkgs, ... }:

let parameters = import ./parameters.nix;
in {
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    nixosFeatures.security.sops
    nixosFeatures.services.mail
    nixosFeatures.services.searx
    nixosFeatures.services.webhosting
  ];

  environment.systemPackages = with pkgs; [ git vim gnupg ];
  system.stateVersion = "22.05";

  users.users = {
    root = {
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../keys/troy.pub.ssh) ];
    };

    nixos = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ git vim ];
    };
  };

  features = {
    security.sops = {
      enable = true;
      defaultSopsFile = ./secrets.yaml;
      sshPath = "/etc/ssh";
    };
    services = {
      webhosting.enable = true;
      mail.enable = true;
      searx.enable = true;
    };
  };
}
