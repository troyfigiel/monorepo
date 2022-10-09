{ pkgs, ... }:

{
  networking.hostName = "cloud-server";
  environment.systemPackages = with pkgs; [ git vim gnupg ];
  system.stateVersion = "22.05";

  localModules.sops = {
    enable = true;
    defaultSopsFile = ./secrets.yaml;
    sshPath = "/etc/ssh";
  };
}
