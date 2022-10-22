{ impermanence, config, lib, ... }:

with lib;
let cfg = config.features.programs.firefox;
in {
  options.features.programs.firefox = {
    enable = mkEnableOption "Firefox";
    defaultBrowser = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.firefox.enable = true;
    }

    # mkIf prevents an infinite recursion when working with cfg compared to optionalAttrs.
    (mkIf cfg.defaultBrowser { home.sessionVariables.BROWSER = "firefox"; })

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories =
          [ ".cache/mozilla" ".mozilla/firefox" ".mozilla/extensions" ];
        allowOther = true;
      };
    })
  ]);
}
