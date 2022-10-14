{ config, lib, pkgs, ... }:

with lib;
let cfg = config.roles.nix;
in {
  options.roles.nix.enable = mkEnableOption "Nix";

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixVersions.stable;
      settings = {
        # Until my own binary cache is set up, let's turn it off.
        # substituters = [ "http://192.168.178.37:10106/nix-binary-cache/" ];
        # trusted-public-keys =
        #  [ "minio.local-1:ZTYgVFeAYCoDqu0HppKRQRy54es8EZ5LVAmZQJO/VDA=" ];
        # trusted-users = [ "troy" ];
        auto-optimise-store = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
      };

      extraOptions = ''
        experimental-features = nix-command flakes
        min-free = ${toString (3 * 1024 * 1024 * 1024)}
        max-free = ${toString (10 * 1024 * 1024 * 1024)}
      '';
    };
  };
}
