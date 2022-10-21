{ inputs, config, nixosModules, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    nixosModules.bluetooth
    nixosModules.docker
    nixosModules.gpg
    nixosModules.locale
    nixosModules.networking
    nixosModules.networkmanager
    nixosModules.nix
    nixosModules.printing
    nixosModules.restic
    nixosModules.sops
    nixosModules.sound
    nixosModules.system
    nixosModules.qemu
    nixosModules.xorg
  ];

  programs.fuse.userAllowOther = true;

  system.stateVersion = "22.05";

  features = {
    sops = {
      enable = true;
      defaultSopsFile = ./secrets.yaml;
      sshPath = "/nix/persist/etc/ssh";
    };
    gpg.enable = true;
    docker.enable = true;
    locale.enable = true;
    nix.enable = true;
    restic.enable = true;
    sound.enable = true;
    system = {
      enable = true;
      games = true;
    };

    qemu.enable = true;

    xorg = {
      enable = true;
      # TODO: What does this do?
      videoDrivers = [ "modesetting" ];
    };

    networking.enable = true;
    networkmanager.enable = true;
    printing.enable = true;
    bluetooth.enable = true;
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
