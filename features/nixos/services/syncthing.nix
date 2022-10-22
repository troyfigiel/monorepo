{ impermanence, config, lib, ... }:

with lib;
let cfg = config.features.services.syncthing;
in {
  options.features.services.syncthing.enable = mkEnableOption "Syncthing";

  config = mkIf cfg.enable (mkMerge [
    {
      # TODO: What does the tray allow me to do extra?
      services.syncthing.enable = true;
    }

    (optionalAttrs impermanence {
      # Syncthing stores everything in the config folder, including xml settings, stateful data such as databases, etc.
      # It is safer to manually add the folders that need to be synced to Syncthing and then persist the data.
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".config/syncthing" ];
    })
  ]);
}
