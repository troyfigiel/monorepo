{ config, lib, ... }:

with lib;
let cfg = config.features.networking;
in {
  options.features.networking.enable = mkEnableOption "networking";

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
