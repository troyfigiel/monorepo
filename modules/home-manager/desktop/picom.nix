{ config, lib, ... }:

with lib;
let cfg = config.my.picom;
in {
  options.my.picom.enable = mkEnableOption "picom";

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;

      # VSync is needed to prevent screen tearing while scrolling.
      vSync = true;
    };
  };
}
