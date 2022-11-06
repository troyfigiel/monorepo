# TODO: Networking should be moved to my machines folder.
{ config, lib, ... }:

with lib;
let cfg = config.my.networking;
in {
  options.my.networking.enable = mkEnableOption "networking";

  config = mkIf cfg.enable {
    networking = {
      extraHosts = ''
        192.168.178.31 rpi
        192.168.178.37 nas
        ${
          (import ../../../machines/cloud-server/parameters.nix).deploy.ip
        } cloud-server
      '';
      useDHCP = lib.mkDefault true;
    };

    services.avahi = {
      enable = true;
      nssmdns = true;
    };
  };
}
