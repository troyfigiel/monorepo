{ config, lib, ... }:

with lib;
let cfg = config.my.gpg;
in {
  options.my.gpg.enable = mkEnableOption "GPG";

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
      # TODO: This is currently stopping me from completely defining my host name in terms of the directory name.
      publicKeys = [
        {
          source = ../../keys/troy.pub.asc;
          trust = 5;
        }
        {
          source = ../../hosts/laptop/key.pub.asc;
          trust = 5;
        }
        {
          source = ../../hosts/cloud-server/key.pub.asc;
          trust = 5;
        }
      ];
    };
  };
}
