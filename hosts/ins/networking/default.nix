{ lib, pkgs, ... }:

{
  imports = [ ./bluetooth.nix ./networkmanager.nix ./syncthing.nix ];

  networking = {
    hostName = "ins";
    extraHosts = ''
      192.168.178.31 rpi
      192.168.178.37 nas
    '';
    useDHCP = lib.mkDefault true;
  };

  # TODO: This works, but need to check how to configure my printers declaratively in NixOS
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
