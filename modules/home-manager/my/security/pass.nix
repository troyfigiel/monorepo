{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my.pass;
in {
  options.my.pass = {
    enable = mkEnableOption "Pass";

    passwordStoreDir = mkOption {
      # TODO: How do I simplify this with xdg.dataHome?
      default = ".local/share/password-store";
      type = types.str;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR =
            "${config.home.homeDirectory}/${cfg.passwordStoreDir}";
        };
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories = [ cfg.passwordStoreDir ];
        allowOther = true;
      };
    })
  ]);
}

