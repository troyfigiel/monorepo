{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  users.users.troy = {
    isNormalUser = true;
    home = "/home/troy";
    description = "Troy Figiel";
    # Why do I not need to set this?
    # shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # I need to give the hashed version of my password with passwordFile,
    # because passwordFile is used directly in /etc/shadow. See:
    # https://nixos.org/manual/nixos/stable/options.html#opt-users.users._name_.passwordFile
    passwordFile = config.sops.secrets.troy-password.path;
  };
}
