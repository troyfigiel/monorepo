{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.games;
in {
  options.features.games.enable = mkEnableOption "system";

  config = mkIf cfg.enable { programs.steam.enable = true; };
}
