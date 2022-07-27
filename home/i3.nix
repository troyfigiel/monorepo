{ config, lib, pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = "Mod4";
        gaps = {
            inner = 10;
            outer = 0;
            smartGaps = true;
        };
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.rofi}/bin/rofi -modi drun -show drun";
        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec ${pkgs.alsa-utils}/bin/amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec ${pkgs.alsa-utils}/bin/amixer set Master 4%-";
          "XF86AudioRaiseVolume" = "exec ${pkgs.alsa-utils}/bin/amixer set Master 4%+";
          #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";
        };
      };
    };
  };
}
