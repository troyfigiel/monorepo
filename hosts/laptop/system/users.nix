{ config, home-manager, pkgs, ... }:

{
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
        [ (builtins.readFile ../../../keys/troy.pub.ssh) ];
    };

    users.root = {
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../../keys/troy.pub.ssh) ];
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