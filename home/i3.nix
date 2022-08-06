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

        window.border = 2;

        gaps = {
          inner = 8;
          outer = -4;
          smartGaps = true;
          smartBorders = "on";
        };

        terminal = "${pkgs.alacritty}/bin/alacritty";

        # TODO: Do not depend on the defaults.
        # I have too many keybindings here to know what is default and what is mine.
        keybindings = lib.mkOptionDefault {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+n" = "workspace next";
          "${modifier}+p" = "workspace prev";

          "${modifier}+v" = ''
            split vertical; exec ${pkgs.libnotify}/bin/notify-send "Tiling vertically."'';
          "${modifier}+z" = ''
            split horizontal; exec ${pkgs.libnotify}/bin/notify-send "Tiling horizontally."'';

          "${modifier}+Ctrl+h" = "move left";
          "${modifier}+Ctrl+j" = "move down";
          "${modifier}+Ctrl+k" = "move up";
          "${modifier}+Ctrl+l" = "move right";

          "${modifier}+m" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
          # This is like a buffer switch in Emacs
          "${modifier}+b" = "exec ${pkgs.rofi}/bin/rofi -show window";
          # "${modifier}+Shift+g" = "mode gaps";
          "${modifier}+q" = "kill";

          "${modifier}+Shift+q" =
            "exec ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur";
          "${modifier}+Shift+b" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Shift+d" =
            "exec ${terminal} -e ${pkgs.lazydocker}/bin/lazydocker";
          "${modifier}+Shift+f" = "exec ${terminal} -e ${pkgs.lf}/bin/lf";
          "${modifier}+Shift+g" =
            "exec ${terminal} -e ${pkgs.lazygit}/bin/lazygit";
          "${modifier}+Shift+l" = "exec ${pkgs.logseq}/bin/logseq";
          "${modifier}+Shift+n" = "exec ${pkgs.nitrokey-app}/bin/nitrokey-app";
          "${modifier}+Shift+s" = "exec ${pkgs.flameshot}/bin/flameshot gui";
          "${modifier}+Shift+t" =
            "exec ${terminal} -e ${pkgs.bpytop}/bin/bpytop";
          "${modifier}+Shift+w" = "exec ${pkgs.wireshark}/bin/wireshark";

          "XF86AudioMute" =
            "exec ${pkgs.alsa-utils}/bin/amixer set Master toggle";
          "XF86AudioLowerVolume" =
            "exec ${pkgs.alsa-utils}/bin/amixer set Master 1%-";
          "XF86AudioRaiseVolume" =
            "exec ${pkgs.alsa-utils}/bin/amixer set Master 1%+";

          #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";

          "XF86MonBrightnessDown" =
            "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
          "XF86MonBrightnessUp" =
            "exec ${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
        };

        # TODO: I hardcoded my wallpaper directory, which is not pure.
        # I should think how I would solve this.
        startup = let wallpaperDir = "/home/troy/.wallpapers";
        in [{
          command =
            "${pkgs.feh}/bin/feh --bg-fill --randomize ${wallpaperDir}/*";
          # TODO: Are these two not the default? Check the code.
          always = true;
          notification = false;
        }];
      };
    };
  };
}
