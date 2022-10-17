{ impermanence, config, lib, ... }:

with lib;
let cfg = config.features.pass;
in {
  options.features.pass.enable = mkEnableOption "Pass";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        };
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories = [ "${config.xdg.dataHome}/password-store" ];
        allowOther = true;
      };
    })
  ]);
}

