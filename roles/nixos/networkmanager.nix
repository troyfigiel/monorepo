{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.roles.networkmanager;
in {
  options.roles.networkmanager.enable = mkEnableOption "NetworkManager";

  config = mkIf cfg.enable (mkMerge [
    {
      networking.networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
      };

      programs.nm-applet.enable = true;
    }

    (optionalAttrs impermanence {
      environment.persistence."/nix/persist".directories = [{
        directory = "/etc/NetworkManager";
        mode = "0755";
      }];
    })
  ]);
}
