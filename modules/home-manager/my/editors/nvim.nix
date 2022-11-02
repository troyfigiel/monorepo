{ config, lib, ... }:

with lib;
let cfg = config.my.nvim;
in {
  options.my.nvim = {
    enable = mkEnableOption "nvim";
    defaultEditor = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
    }

    (mkIf cfg.defaultEditor { home.sessionVariables.EDITOR = "vi"; })
  ]);
}
