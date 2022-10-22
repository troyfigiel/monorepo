{ config, lib, ... }:

with lib;
let cfg = config.features.programs.games;
in {
  options.features.programs.games.enable = mkEnableOption "system";

  config = mkIf cfg.enable { programs.steam.enable = true; };
}
