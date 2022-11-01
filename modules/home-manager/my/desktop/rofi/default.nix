{ config, lib, ... }:

with lib;
let cfg = config.my.rofi;
in {
  options.my.rofi.enable = mkEnableOption "Rofi";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;

      extraConfig = {
        # TODO: Add emoji, rofi-pass?
        # Does this work properly?
        modi = "drun,window";
        display-drun = "Applications:";
        display-window = "Windows:";
        font = "Inconsolata Medium 16";
        drun-display-format = "{icon} {name}";
        show-icons = true;
        icon-theme = "Papirus";
        kb-row-up = "Super+k";
        kb-row-down = "Super+j";
      };

      # TODO: Add rounded corners
      # TODO: Move theme to rofi.nix
      # TODO: Clean up some variables and simplify theme
      theme = ./rofi-theme.rasi;
    };
  };
}
