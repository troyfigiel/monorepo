{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.dunst;
in {
  options.features.dunst.enable = mkEnableOption "dunst";

  config = mkIf cfg.enable {
    # TODO: Create a systemd service that checks the battery every minute
    # and sends a notification if the battery is low.
    services.dunst = {
      enable = true;

      iconTheme = {
        # TODO: I should set some keybindings for dunstctl
        # TODO: How can I make the papirus icon theme monochrome?
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };

      settings = {
        global = {
          width = 400;
          height = 300;
          offset = "10x20";
          origin = "top-right";

          frame_width = 2;
          frame_color = "#aaaaaa";
          transparency = 30;

          font = "Inconsolata 12";
          text_icon_padding = 20;
          markup = "full";
          format = ''
            <b>%s</b>
            %b'';

          alignment = "left";
          vertical_alignment = "center";
        };

        urgency_low = {
          background = "#11121D";
          foreground = "#FFFFFF";
          timeout = 10;
          new_icon = "bell";
        };

        urgency_normal = {
          background = "#11121D";
          foreground = "#FFFFFF";
          timeout = 10;
          new_icon = "bell";
        };

        urgency_critical = {
          background = "#FF8060";
          foreground = "#000000";
          timeout = 0;
        };
      };
    };
  };
}
