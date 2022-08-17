{ config, ... }:

{
  programs.rofi = {
    enable = true;

    extraConfig = {
      kb-row-up = "Super+k";
      kb-row-down = "Super+j";
    };

    # TODO: Add rounded corners
    # TODO: Move theme to rofi.nix
    # TODO: Clean up some variables and simplify theme
    theme = ./config/rofi-theme.rasi;
  };
}
