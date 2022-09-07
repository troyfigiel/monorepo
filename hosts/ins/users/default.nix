{ config, home-manager, pkgs, ... }:

{
  # TODO: Should I set the group to be "troy" as well?
  users = {
    mutableUsers = false;

    users.troy = {
      isNormalUser = true;
      home = "/home/troy";
      description = "Troy Figiel";
      shell = pkgs.zsh;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      # I need to give the hashed version of my password with passwordFile,
      # because passwordFile is used directly in /etc/shadow. See:
      # https://nixos.org/manual/nixos/stable/options.html#opt-users.users._name_.passwordFile
      passwordFile = config.sops.secrets.troy-password.path;
      openssh.authorizedKeys.keys = [ (builtins.readFile ./key.pub) ];
    };

    users.root = {
      openssh.authorizedKeys.keys = [ (builtins.readFile ./key.pub) ];
    };
  };
}
