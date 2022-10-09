{ config, lib, pkgs, ... }:

let
  cfg = config.localModules.networkmanager;
  inherit (lib) mkEnableOption mkIf;
in {
  options.localModules.networkmanager.enable = mkEnableOption "NetworkManager";

  config = mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };

    programs.nm-applet.enable = true;

    environment.persistence."/nix/persist".directories = [{
      directory = "/etc/NetworkManager";
      mode = "0755";
    }];
  };
}
