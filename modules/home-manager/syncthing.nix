{ config, lib, ... }:

with lib;
let cfg = config.localModules.syncthing;
in {
  options.localModules.syncthing.enable = mkEnableOption "Syncthing";

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # TODO: What does the tray allow me to do extra?
      # tray.enable = true;
    };

    # Syncthing stores everything in the config folder, including xml settings, stateful data such as databases, etc.
    # It is safer to manually add the folders that need to be synced to Syncthing and then persist the data.
    home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
      [ ".config/syncthing" ];
  };
}
