{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "vtr";

  users.users.root = {
    openssh.authorizedKeys.keys = [ (builtins.readFile ./key.pub) ];
  };

  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ git vim hello ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ./key.pub) ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  system.stateVersion = "22.05";
}

