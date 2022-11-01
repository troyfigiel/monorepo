{ config, lib, ... }:

with lib;
let cfg = config.my.sound;
in {
  options.my.sound.enable = mkEnableOption "Sound";

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
