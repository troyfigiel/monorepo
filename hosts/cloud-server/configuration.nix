{ pkgs, ... }:

{
  networking.hostName = "cloud-server";
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

  localModules.sops = {
    enable = true;
    defaultSopsFile = ./secrets.yaml;
    sshPath = "/etc/ssh";
  };
}