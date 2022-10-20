{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.emacs.init;
in {
  imports = [ ./early-init.nix ./init.nix ];

  options.programs.emacs.init = {
    enable = mkEnableOption "Emacs configuration";

    evil = {
      enable = mkEnableOption "Add evil and evil-collection integration.";
      config = mkOption {
        type = types.lines;
        default = "";
        # TODO: Write a better description
        description = ''
          Configuration lines to add ...
        '';
      };
    };

    # TODO: This does not do anything yet. I have to implement it soon.
    # The code that needs to go in the init-file is commented out.
    no-littering = {
      enable = mkEnableOption "Add no-littering integration";
      config = mkOption {
        type = types.lines;
        default = "";
        # TODO: Write a better description
        description = ''
          Configuration lines to add ...
        '';
      };
    };

    usePackage = mkOption {
      type = types.attrsOf (types.submodule (import ./use-package-options.nix));
      default = { };
      example = literalExpression ''
        {
          nix-mode = {
            mode = [ '''"\\.nix\\'"''' ];
          };
        }
      '';
      description = ''
        Attribute set of use-package configurations.
      '';
    };
  };

  config = mkIf (config.programs.emacs.enable && cfg.enable) {
    # Collect the extra packages that should be included in the user profile.
    # These are typically tools called by Emacs packages.
    home.packages = concatMap (v: v.extraPackages)
      (filter (getAttr "enable") (builtins.attrValues cfg.usePackage));
  };
}
