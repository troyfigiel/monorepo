{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.background;
in {
  options.my.background = {
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
