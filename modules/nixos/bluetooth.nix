{ impermanence, config, lib, ... }:

let
  cfg = config.localModules.bluetooth;
  inherit (lib) mkEnableOption mkIf optionalAttrs mkMerge;
in {
  options.localModules.bluetooth.enable = mkEnableOption "Bluetooth";

  # TODO: I get the attempt to call something which is not a function when I try to add mkIf cfg.enable. Why?
  config = mkMerge [
    {
      services.blueman.enable = true;
    }

    # Trusting a bluetooth device is needed to automatically connect.
    (optionalAttrs (impermanence) {
      environment.persistence."/nix/persist".directories =
        [ "/var/lib/bluetooth" ];
    })
  ];
}
