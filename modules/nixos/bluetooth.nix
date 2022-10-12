{ impermanence, config, lib, ... }:

with lib;
let cfg = config.localModules.bluetooth;
in {
  options.localModules.bluetooth.enable = mkEnableOption "Bluetooth";

  # TODO: I get the attempt to call something which is not a function when I try to add mkIf cfg.enable. Why?
  config = mkIf cfg.enable (mkMerge [
    {
      services.blueman.enable = true;
    }

    # Trusting a bluetooth device is needed to automatically connect.
    (optionalAttrs impermanence {
      environment.persistence."/nix/persist".directories =
        [ "/var/lib/bluetooth" ];
    })
  ]);
}
