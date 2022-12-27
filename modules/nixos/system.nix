{ impermanence, config, lib, pkgs, self, ... }:

with lib;
let cfg = config.my.system;
in {
  options.my.system = { enable = mkEnableOption "system"; };

  config = mkIf cfg.enable (mkMerge [
    {
      # TODO: I have to move the packages to the respective modules that use them.
      environment.systemPackages = with pkgs; [
        nix-index
        git
        python3
        inxi
        vim
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
