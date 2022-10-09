{ config, lib, ... }:

let
  cfg = config.localModules.bluetooth;
  inherit (lib) mkEnableOption mkIf;
in {
  options.localModules.bluetooth.enable = mkEnableOption "Bluetooth";

  config = mkIf cfg.enable {
    services.blueman.enable = true;

    # Trusting a bluetooth device is needed to automatically connect.
    environment.persistence."/nix/persist".directories =
      [ "/var/lib/bluetooth" ];
  };
}
