{ config, lib, pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = "Mod4";
        bars = [ ];

        window.border = 0;

        gaps = {
          inner = 15;
          outer = 2;
        };

        keybindings = let
          modifier = config.xsession.windowManager.i3.config.modifier;
          browser = "${pkgs.firefox}/bin/firefox";
          menu = "${pkgs.rofi}/bin/rofi";
          terminal = "${pkgs.alacritty}/bin/alacritty";
          audio = "${pkgs.alsa-utils}/bin/amixer";
          brightness = "${pkgs.brightnessctl}/bin/brightnessctl";
        in lib.mkOptionDefault {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+v" = "split vertical";
          "${modifier}+z" = "split horizontal";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+d" = "exec ${menu} -modi drun -show drun";
          "${modifier}+Shift+d" = "exec ${menu} -show window";

          "${modifier}+b" = "exec ${browser}";

          "XF86AudioMute" =
            "exec ${audio} set Master toggle";
          "XF86AudioLowerVolume" =
            "exec ${audio} set Master 4%-";
          "XF86AudioRaiseVolume" =
            "exec ${audio} set Master 4%+";
          #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";
          "XF86MonBrightnessDown" =
            "exec ${brightness} set 4%-";
          "XF86MonBrightnessUp" =
            "exec ${brightness} set 4%+";
        };
      };
    };
  };
}
