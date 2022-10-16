{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    ../../features/nixos/mail.nix
    ../../features/nixos/sops.nix
    ../../features/nixos/searx.nix
    ../../features/nixos/website.nix
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
    sops = {
      enable = true;
      defaultSopsFile = ./secrets.yaml;
      sshPath = "/etc/ssh";
    };
    website.enable = true;
    mail.enable = true;
    searx.enable = true;
  };
}
