{ lib, ... }:

{
  imports = [ ./bluetooth.nix ./networkmanager.nix ./printing.nix ];

  networking = {
    hostName = "ins";
    extraHosts = ''
      192.168.178.31 rpi
      192.168.178.37 nas
    '';
    useDHCP = lib.mkDefault true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
