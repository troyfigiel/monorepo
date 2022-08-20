{ lib, ... }:

{
  imports = [ ./networkmanager.nix ./syncthing.nix ];

  networking = {
    hostName = "inspiron";
    extraHosts = "192.168.178.31 raspberry";
    useDHCP = lib.mkDefault true;
  };

  services.blueman.enable = true;
  services.printing.enable = true;
}
