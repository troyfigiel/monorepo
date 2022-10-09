{ lib, ... }:

{
  networking = {
    hostName = "laptop";
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

  localModules = {
    networkmanager.enable = true;
    printing.enable = true;
    bluetooth.enable = true;
  };
}
