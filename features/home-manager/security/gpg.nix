{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.security.gpg;
in {
  options.features.security.gpg.enable = mkEnableOption "GPG";

  config = mkIf cfg.enable {
    # Is it a problem I have a home service as well as a system service?
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      # What does the extra socket do?
      enableExtraSocket = true;
      sshKeys = [ "8ABF0116DA24246700017F956358D89FE8B148B8" ];
      pinentryFlavor = "gtk2";
      verbose = true;
    };

    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = ../../keys/troy.pub.asc;
          trust = 5;
        }
        {
          source = ../../keys/laptop.pub.asc;
          trust = 5;
        }
        {
          source = ../../keys/cloud-server.pub.asc;
          trust = 5;
        }
      ];
    };
  };
}
