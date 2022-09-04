{ lib, ... }:

{
  imports = [ ./bluetooth.nix ./networkmanager.nix ./syncthing.nix ];

  networking = {
    hostName = "inspiron";
    extraHosts = ''
      192.168.178.31 raspberry
      192.168.178.37 nas
      80.240.27.131 vulture
    '';
    useDHCP = lib.mkDefault true;
  };

  services.printing.enable = true;
}
