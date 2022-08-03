{ lib, pkgs, ... }:

{
  xsession = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      config = rec {
        modifier = "Mod4";
        bars = [ ];

        window.border = 0;

        gaps = {
          inner = 15;
          outer = 2;
        };

        keybindings = lib.mkOptionDefault {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+v" = "split vertical; exec ${pkgs.libnotify}/bin/notify-send \"Tiling vertically.\"";
          "${modifier}+z" = "split horizontal; exec ${pkgs.libnotify}/bin/notify-send \"Tiling horizontally.\"";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
          # This is like a buffer switch in Emacs
          "${modifier}+b" = "exec ${pkgs.rofi}/bin/rofi -show window";
          "${modifier}+Shift+s" = "exec ${pkgs.flameshot}/bin/flameshot gui";

          "${modifier}+Ctrl+f" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Ctrl+l" = "exec ${pkgs.logseq}/bin/logseq";
          "${modifier}+Ctrl+t" = "exec ${pkgs.bpytop}/bin/bpytop";
          "${modifier}+Ctrl+w" = "exec ${pkgs.wireshark}/bin/wireshark";

          "XF86AudioMute" =
            "exec ${pkgs.alsa-utils}/bin/amixer set Master toggle";
          "XF86AudioLowerVolume" =
            "exec ${pkgs.alsa-utils}/bin/amixer set Master 4%-";
          "XF86AudioRaiseVolume" =
            "exec ${pkgs.alsa-utils}/bin/amixer set Master 4%+";

          #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";

          "XF86MonBrightnessDown" =
            "exec ${pkgs.brightnessctl}/bin/brightnessctl set 4%-";
          "XF86MonBrightnessUp" =
            "exec ${pkgs.brightnessctl}/bin/brightnessctl set 4%+";
        };
      };
    };
  };
}
