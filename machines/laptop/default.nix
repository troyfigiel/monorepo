{ inputs, config, nixosFeatures, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home-manager.nix
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    nixosFeatures.hardware.sound
    nixosFeatures.development.docker
    nixosFeatures.security.nitrokey
    nixosFeatures.desktop.system
    nixosFeatures.network.networking
    nixosFeatures.programs.games
    nixosFeatures.security.sops
    nixosFeatures.development.qemu
    nixosFeatures.desktop.i3
  ];

  programs.fuse.userAllowOther = true;

  system.stateVersion = "22.05";

  features = {
    security.sops = {
      enable = true;
      defaultSopsFile = ./secrets.yaml;
      sshPath = "/nix/persist/etc/ssh";
    };

    security.nitrokey.enable = true;
    development.docker.enable = true;
    desktop.system.enable = true;
    network.networking = {
      enable = true;
      restic.enable = true;
      printing.enable = true;
    };
    hardware.sound = {
      enable = true;
      headset.enable = true;
    };
    programs.games.enable = true;

    development.qemu.host.enable = true;

    desktop.i3 = {
      enable = true;
      # TODO: What does this do?
      videoDrivers = [ "modesetting" ];
    };
  };

  sops.secrets.troy-password = { neededForUsers = true; };

  # TODO: Should I set the group to be "troy" as well?
  users = {
    mutableUsers = false;

    users.troy = {
      isNormalUser = true;
      home = "/home/troy";
      description = "Troy Figiel";
      shell = pkgs.zsh;
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
      passwordFile = config.sops.secrets.troy-password.path;
      # This is needed to be able to call deploy using my Nitrokey.
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../keys/troy.pub.ssh) ];
    };

    users.root = {
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../keys/troy.pub.ssh) ];
    };
  };

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    users.root = {
      home = "/root";
      directories = [ ".gnupg" ];
      files = [ ".ssh/known_hosts" ];
    };
  };
}
