{ lib, ... }:

{
  imports = [ ./bluetooth.nix ./networkmanager.nix ./syncthing.nix ];

  networking = {
    hostName = "ins";
    extraHosts = ''
      192.168.178.31 rpi
      192.168.178.37 nas
      troyfigiel.com vtr
    '';
    useDHCP = lib.mkDefault true;
  };

  services.printing.enable = true;
}
