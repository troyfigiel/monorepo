{ lib, pkgs, ... }:

{
  home-manager.users.troy = {
    xsession = {
      enable = true;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        config = let modifier = "Mod4";
        in {
          inherit modifier;
          bars = [ ];

          window.border = 2;

          gaps = {
            inner = 8;
            outer = -4;
            smartGaps = true;
            smartBorders = "on";
          };

          # TODO: Do not depend on the defaults.
          # I have too many keybindings here to know what is default and what is mine.
          keybindings = lib.mkOptionDefault {
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";

            "${modifier}+a" = "focus parent";
            "${modifier}+d" = "focus child";

            "${modifier}+n" = "workspace next";
            "${modifier}+p" = "workspace prev";

            "${modifier}+v" = ''
              split vertical; exec ${pkgs.dunst}/bin/dunstify "i3" "Tiling vertically"
            '';
            "${modifier}+z" = ''
              split horizontal; exec ${pkgs.dunst}/bin/dunstify "i3" "Tiling horizontally"
            '';

            "${modifier}+Ctrl+h" = "move left";
            "${modifier}+Ctrl+j" = "move down";
            "${modifier}+Ctrl+k" = "move up";
            "${modifier}+Ctrl+l" = "move right";

            "${modifier}+Ctrl+n" = "move container to workspace next";
            "${modifier}+Ctrl+p" = "move container to workspace prev";

            "${modifier}+m" = "exec ${pkgs.rofi}/bin/rofi -show drun";
            "${modifier}+b" = "exec ${pkgs.rofi}/bin/rofi -show window";
            "${modifier}+i" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
            # "${modifier}+Shift+g" = "mode gaps";
            "${modifier}+q" = "kill";

            "${modifier}+Shift+q" =
              "exec ${pkgs.betterlockscreen}/bin/betterlockscreen";

            "XF86AudioMute" = ''
              exec ${pkgs.alsa-utils}/bin/amixer set Master toggle; exec ${pkgs.dunst}/bin/dunstify "Toggling mute"
            '';
            "XF86AudioLowerVolume" = ''
              exec ${pkgs.alsa-utils}/bin/amixer set Master 1%-; exec ${pkgs.dunst}/bin/dunstify "Decreasing volume"
            '';
            "XF86AudioRaiseVolume" = ''
              exec ${pkgs.alsa-utils}/bin/amixer set Master 1%+; exec ${pkgs.dunst}/bin/dunstify "Increasing volume"
            '';

            #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
            #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
            #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";

            "XF86MonBrightnessDown" = ''
              exec ${pkgs.brightnessctl}/bin/brightnessctl set 3%-; exec ${pkgs.dunst}/bin/dunstify "Decreasing brightness"
            '';
            "XF86MonBrightnessUp" = ''
              exec ${pkgs.brightnessctl}/bin/brightnessctl set 3%+; exec ${pkgs.dunst}/bin/dunstify "Increasing brightness"
            '';
          };

          startup = [
            {
              command =
                "${pkgs.feh}/bin/feh --bg-fill ${../../assets/nixos.jpg}";
              always = true;
              notification = false;
            }
            {
              command =
                "${pkgs.betterlockscreen}/bin/betterlockscreen --update ${
                  ../../assets/nixos.jpg
                }";
              always = true;
              notification = false;
            }
          ];
        };
      };
    };
  };
}
