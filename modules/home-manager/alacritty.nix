{ config, lib, ... }:

with lib;
let cfg = config.localModules.alacritty;
in {
  options.localModules.alacritty.enable = mkEnableOption "Alacritty";

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = let
        background-color = "#191919";
        foreground-color = "#d8dee9";
      in {
        window = {
          title = "Terminal";
          opacity = 0.8;
          padding.x = 2;
          padding.y = 2;
          dimensions = {
            lines = 75;
            columns = 100;
          };
        };

        scrolling = {
          multiplier = 1;
          history = 10000;
        };

        font = {
          normal.family = "Inconsolata";
          style = "Medium";
          size = 12;
        };

        colors = {
          primary = {
            background = background-color;
            foreground = foreground-color;
          };

          cursor = {
            text = background-color;
            cursor = foreground-color;
          };

          normal = {
            black = "#191919";
            red = "#b02626";
            green = "#40a62f";
            yellow = "#f2e635";
            blue = "#314ad0";
            magenta = "#b30ad0";
            cyan = "#32d0fc";
            white = "#acadb1";
          };

          bright = {
            black = "#36393d";
            red = "#ce2727";
            green = "#47c930";
            yellow = "#fff138";
            blue = "#2e4bea";
            magenta = "#cc15ed";
            cyan = "#54d9ff";
            white = "#dbdbdb";
          };

          dim = {
            black = "#676f78";
            red = "#b55454";
            green = "#78a670";
            yellow = "#faf380";
            blue = "#707fd0";
            magenta = "#c583d0";
            cyan = "#8adaf1";
            white = "#e0e3e7";
          };
        };
      };
    };
  };
}
