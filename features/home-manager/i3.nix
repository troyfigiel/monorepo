{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.i3;
in {
  # TODO: Something changed with the latest flake update. I now have a bar with the name of the window in every i3 mode.
  options.features.i3.enable = mkEnableOption "i3";

  config = mkIf cfg.enable {
    xsession = {
      enable = true;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        config = let
          modifier = "Mod4";
          terminal = "${pkgs.alacritty}/bin/alacritty";
        in {
          inherit modifier terminal;
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
              "exec ${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur";

            "XF86AudioMute" = ''
              exec ${pkgs.alsa-utils}/bin/amixer set Master toggle; exec ${pkgs.dunst}/bin/dunstify "Toggling mute"
            '';
            "XF86AudioLowerVolume" = ''
              exec ${pkgs.alsa-utils}/bin/amixer set Master 2%-; exec ${pkgs.dunst}/bin/dunstify "Decreasing volume"
            '';
            "XF86AudioRaiseVolume" = ''
              exec ${pkgs.alsa-utils}/bin/amixer set Master 2%+; exec ${pkgs.dunst}/bin/dunstify "Increasing volume"
            '';

            #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
            #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
            #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";

            "XF86MonBrightnessDown" = ''
              exec ${pkgs.brightnessctl}/bin/brightnessctl set 4%-; exec ${pkgs.dunst}/bin/dunstify "Decreasing brightness"
            '';
            "XF86MonBrightnessUp" = ''
              exec ${pkgs.brightnessctl}/bin/brightnessctl set 4%+; exec ${pkgs.dunst}/bin/dunstify "Increasing brightness"
            '';
          };

          startup = [
            # TODO: I should probably add something like this. How can I do that?
            # mkIf
            # config.features.bluetooth.enable
            # {
            #   command = "${pkgs.blueman}/bin/blueman-applet";
            #   always = true;
            #   notification = false;
            # }
          ];
          #  # I just want to icon in the tray, not the entire screen on start up.
          #  # TODO: What is the right command to use for this?
          #  command = "${pkgs.nitrokey-app}/bin/nitrokey-app";
          #  always = true;
          #  notification = false;
        };
      };
    };
  };
}
