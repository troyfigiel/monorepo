{ impermanence, config, lib, pkgs, ... }:

let
  cfg = config.localModules.networkmanager;
  inherit (lib) mkEnableOption mkIf optionalAttrs mkMerge;
in {
  options.localModules.networkmanager.enable = mkEnableOption "NetworkManager";

  config = mkMerge [
    {
      networking.networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
      };

      programs.nm-applet.enable = true;
    }

    (optionalAttrs (impermanence) {
      environment.persistence."/nix/persist".directories = [{
        directory = "/etc/NetworkManager";
        mode = "0755";
      }];
    })
  ];
}
