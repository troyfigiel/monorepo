{ config, lib, ... }:

with lib;
let cfg = config.my.picom;
in {
  options.my.picom.enable = mkEnableOption "picom";

  config = mkIf cfg.enable {
    # TODO:The tray randomly disappears. Maybe a compositor issue?
    services.picom = {
      enable = true;
      experimentalBackends = true;

      fade = true;
      fadeDelta = 5;

      shadow = true;
      shadowOffsets = [ (-7) (-7) ];
      shadowOpacity = 0.7;
      shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];

      activeOpacity = 1.0;
      inactiveOpacity = 1.0;
      menuOpacity = 0.8;

      backend = "glx";
      vSync = true;

      settings = {
        shadow-radius = 7;
        clear-shadow = true;
        frame-opacity = 0.3;
        blur-method = "dual_kawase";
        blur-strength = 8;
        alpha-step = 6.0e-2;
        detect-client-opacity = true;
        detect-rounded-corners = true;
        paint-on-overlay = true;
        detect-transient = true;
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
      };
    };
  };
}
