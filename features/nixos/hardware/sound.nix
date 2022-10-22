{ impermanence, config, lib, ... }:

with lib;
let cfg = config.features.hardware.sound;
in {
  options.features.hardware.sound = {
    enable = mkEnableOption "Enable sound features.";

    # I only use bluetooth for my headset.
    headset.enable = mkEnableOption "Enable headset features.";
  };

  config = (mkMerge [
    (mkIf cfg.enable {
      # TODO: What does rtkit do?
      security.rtkit.enable = true;
      sound.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      #services.mpd.enable = true;
    })

    (mkIf (cfg.enable && cfg.headset.enable) (mkMerge [
      {
        services.blueman.enable = true;
      }

      # Trusting a bluetooth device is needed to automatically connect.
      (optionalAttrs impermanence {
        environment.persistence."/nix/persist".directories =
          [ "/var/lib/bluetooth" ];
      })
    ]))
  ]);
}
