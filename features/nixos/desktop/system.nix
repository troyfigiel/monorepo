{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.desktop.system;
in {
  options.features.desktop.system = mkEnableOption "Default system settings.";

  config = mkIf cfg.enable (mkMerge [
    {
      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.utf8";
      console.keyMap = "de";

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

      # This is approximately how I should do an auto-upgrade, but the code here
      # probably does not work as-is.

      # system.autoUpgrade = {
      #   enable = true;
      #   allowReboot = true;
      #   # What is self.outPath?
      #   flake = self.outPath;
      #   # These are the flags going into nixos-rebuild
      #   flags = [
      #     "--recreate-lock-file"
      #     "--no-write-lock-file"
      #     "-L" # print build logs
      #   ];
      #   dates = "daily";
      #   # I might want to change the rebootWindow parameters.
      # };

      environment.systemPackages = with pkgs; [
        git
        inxi # To detect hardware
        vim
        # TODO: Where should I move brightnessctl?
        brightnessctl
      ];
    }

    (optionalAttrs impermanence {
      environment.persistence."/nix/persist" = {
        directories = [
          "/etc/nixos"
          "/var/log"
          # This gets rid of the local sysadmin lecture message.
          # TODO: This could be symlinked in place, because it only requires a file with username to exist.
          {
            directory = "/var/db/sudo/lectured";
            mode = "0700";
          }
        ];
        files = [ "/etc/machine-id" ];
      };
    })
  ]);
}
