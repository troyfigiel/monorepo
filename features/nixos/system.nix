{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.system;
in {
  options.features.system = {
    enable = mkEnableOption "system";
    games = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
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

      # TODO: I have to move the packages to the respective modules that use them.
      environment.systemPackages = with pkgs; [
        sddm-sugar-candy
        nix-index
        git
        python3
        inxi
        vim
        brightnessctl
      ];
    }

    (mkIf cfg.games {
      # TODO: Is there a way to set this up with home-manager? Not system-wide
      # TODO: How do I use Proton in Nix?
      programs.steam.enable = true;
    })

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