{ config, lib, ... }:

with lib;
let cfg = config.roles.networking;
in {
  options.roles.networking.enable = mkEnableOption "networking";

  config = mkIf cfg.enable {
    networking = {
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
  };
}
