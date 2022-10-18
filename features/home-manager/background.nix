{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.background;
in {
  options.features.background = {
    enable = mkEnableOption "Background";
    wallpaperDirectory = mkOption {
      default = toString pkgs.wallpaper;
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.random-background = {
      enable = true;
      imageDirectory = cfg.wallpaperDirectory;
    };
  };
}
