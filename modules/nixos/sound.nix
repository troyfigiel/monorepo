{ config, lib, ... }:

with lib;
let cfg = config.localModules.sound;
in {
  options.localModules.sound.enable = mkEnableOption "Sound";

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
