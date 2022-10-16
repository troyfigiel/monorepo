{ config, lib, ... }:

with lib;
let cfg = config.features.sound;
in {
  options.features.sound.enable = mkEnableOption "Sound";

  config = mkIf cfg.enable {
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
  };
}
