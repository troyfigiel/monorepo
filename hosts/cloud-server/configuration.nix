{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./sshd.nix
    ./users.nix
    ./website
  ];

  networking.hostName = "cloud-server";
  environment.systemPackages = with pkgs; [ git vim gnupg ];
  system.stateVersion = "22.05";
}
